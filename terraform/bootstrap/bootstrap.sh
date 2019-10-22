#!/usr/bin/env bash

set -eu
set -o pipefail

function chart_installed(){
    helm list | grep DEPLOYED | grep "${1}" >> /dev/null
}

# -------------- SETUP ----------------
POSITIONAL=()
SUDO=""
UPDATE_HOSTS="YES"
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        ## Added to allow sudo if user is not in docker group
        -s|--sudo)
        SUDO="sudo "
        shift # past argument
        ;;
        -h|--no-update-hosts)
        unset UPDATE_HOSTS
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}" # restore positional parameters

if [[ "$(kubectl config current-context)" == "minikube" ]]; then
MINIKUBE_IP=$(minikube ip)
fi

pushd .

# -------------- HELM -----------------
cd ../../../helm-charts

printf "\nPreparing kube-registry...\n"

# TODO - use local terraform to make this idempotent?
# TODO - expose this as an ingress
## Kubernetes Registry
if ! chart_installed kube-registry; then
    helm install --wait -n kube-registry celmatix/kube-registry
fi

# TODO - eliminate this using coredns and docker.celmatix.net ingress
# Need to test if kube-registry is up before continuing, and when up, start the port-forward
set +o pipefail
POD=$(kubectl get pods --namespace kube-system -l k8s-app=kube-registry-upstream \
      -o template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
pkill -f "kubectl port-forward --namespace kube-system .* 5000:5000" || true
sleep 10
kubectl port-forward --namespace kube-system $POD 5000:5000 > /dev/null &
while ! (curl -s http://localhost:5000/v2/ > /dev/null); do
  sleep 10
done
set -o pipefail

../conf-mgmt/terraform/bootstrap/ensure_mac_docker_forward.sh

printf "\nFinished preparing kube-registry...\n"

# ---------- DOCKER-IMAGES ------------

printf "\nBuilding docker-images...\n"

cd ../docker-images
${SUDO} make deploy-docker

#printf "\nBuilding metabase...\n"
#
#cd ../metabase
#${SUDO} make deploy-docker
#
#printf "\nBuilding drill...\n"
#
#cd ../drill
#${SUDO} make deploy-docker

# ------------ BOOTSTRAP --------------
cd ../conf-mgmt/terraform/bootstrap

printf "\nPreparing terraform...\n"

kubectl create -f ./terraform-state-pvc.yml || true
kubectl create -f ./terraform-helm-state-pvc.yml || true

cd ../apply
# TODO - add tffile for kube-registry
# TODO - fix this application order (coredns depends on helm-repo in minio)
# TODO - add backup / update layer (ec2-snapshotter / keel)
./apply.sh --reset ../kubernetes/minio.tf

printf "\nPreparing minio...\n"
# TODO - migrate this to a terraform provider (fork terraform-kubernetes-provider)
# TODO - eliminate downtime for prod deployments
kubectl delete ingress minio-minio || true
kubectl create -f ../ingresses/minio.yml

# TODO - centralize domain names (coredns, externaldns)
MINIO_URL="minio.celmatix.net"
if [[ (-n UPDATE_HOSTS) && (-n MINIKUBE_IP) ]]; then
../utils/add_url_to_hosts.sh ${MINIO_URL}=${MINIKUBE_IP}
fi

cd ../bootstrap

# TODO - migrate this to a terraform provider
kubectl delete job minio-bucket-create || true
kubectl create -f minio-bucket-create.yml
printf "Waiting for bucket creation..."
../utils/wait-for-job.sh minio-bucket-create
printf "\n"

printf "\nDone preparing minio...\n"

printf "\nPreparing helm-repo...\n"
cd ../../../helm-charts

make deploy-charts

printf "\nFinished preparing helm-repo...\n"

# -------------- CERTS ----------------
printf "\nPreparing ca...\n"
cd ../conf-mgmt/terraform/bootstrap

./generate-ca.sh

printf "\nFinished preparing ca...\n"

# ------------ TERRAFORM --------------
cd ../apply

printf "\nRunning terraform...\n"
# ./apply.sh ../kubernetes

#./apply.sh ../kubernetes/helm.tf ../kubernetes/coredns.tf

## TODO - centralize domain names (coredns, externaldns)
#./apply.sh ../kubernetes/metabase.tf
#METABASE_URL="metabase.celmatix.net"
#if [[ -n UPDATE_HOSTS && -n MINIKUBE_IP ]]; then
#../utils/add_url_to_hosts.sh "${METABASE_URL}=${MINIKUBE_IP}"
#fi
#
## TODO - centralize domain names (coredns, externaldns)
#./apply.sh ../kubernetes/drill.tf
#DRILL_URL="drill.celmatix.net"
#if [[ -n UPDATE_HOSTS && -n MINIKUBE_IP ]]; then
#../utils/add_url_to_hosts.sh "${DRILL_URL}=${MINIKUBE_IP}"
#fi
#printf "\nFinished running terraform...\n"

popd
