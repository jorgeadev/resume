#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$DIR/.applied"

POSITIONAL=()
JOB_ONLY=""
while [[ $# -gt 0 ]]; do
    key="$1"

    case ${key} in
        ## Added to allow sudo if user is not in docker group
        -j|--job-only)
        JOB_ONLY="YES"
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}" # restore positional parameters

kubectl delete job terraform-apply
kubectl delete configmap terraform-config

clear_charts() {
    helm list --all | cut -d' ' -f1 | cut -f1 | tail -n +2 | grep -Ev "minio|kube-registry|coredns" | xargs -I{} helm delete {} --purge
}

clear_ns() {
    kubectl get ns | awk '{print $1}' | tail -n +2 | grep -Ev "default|kube-public|kube-system" | xargs -I \{\} kubectl delete ns \{\}
}

if [[ -z "${JOB_ONLY}" ]]; then
    clear_charts
    clear_ns

    kubectl delete pvc terraform-state
    kubectl create -f ../bootstrap/terraform-state-pvc.yml

    kubectl delete pvc terraform-helm-state
    kubectl create -f ../bootstrap/terraform-helm-state-pvc.yml

    rm -rf ${CONFIG_DIR} && echo "apply.sh cache cleared"
fi

