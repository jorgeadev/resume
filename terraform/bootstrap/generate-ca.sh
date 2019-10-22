#!/usr/bin/env bash

set -eu
set -o pipefail

PASS=$(openssl rand -base64 20)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.certs"

POSITIONAL=()

if [[ -d $DIR ]]; then
REGENERATE_CERTS="NO"
else
REGENERATE_CERTS="YES"
fi
while [[ $# -gt 0 ]]; do
    key="$1"

    case ${key} in
        -r|--regenerate-certs)
        REGENERATE_CERTS="YES"
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}" # restore positional parameters

# TODO - cache certs to prevent need for restart
if [[ "${REGENERATE_CERTS}" == "YES" ]]; then
    rm $DIR/* || true
fi

mkdir -p $DIR
pushd .
cd $DIR

if [[ "${REGENERATE_CERTS}" == "YES" ]]; then
    echo "$PASS" > kafkaCA.pass
    openssl req -new -x509 -keyout kafkaCA.key -out kafkaCA.crt -days 3650 -subj '/CN=kafkaCA/O=celmatix' -passin pass:$PASS -passout pass:$PASS
    keytool -keystore kafka.truststore.jks -noprompt -storepass $PASS -alias CARoot -import -file kafkaCA.crt
fi

kubectl delete secret kafka-ca || true
kubectl create secret generic kafka-ca --from-file=kafkaCA.pass --from-file=./kafkaCA.key --from-file=./kafkaCA.crt --from-file=kafka.truststore.jks

popd
