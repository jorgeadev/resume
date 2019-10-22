#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$DIR/.applied"
RESET_SCRIPT="$DIR/reset.sh"
TERRAFORM_APPLY_JOB="$DIR/terraform-apply.yml"

POSITIONAL=()
RESET=""
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        ## Added to allow sudo if user is not in docker group
        -r|--reset)
        RESET="YES"
        shift # past argument
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}" # restore positional parameters

if [[ ${RESET} ]]; then
    echo "Resetting existing terraform state and deleting installed charts..."
    ${RESET_SCRIPT}
else
    echo "Cleaning up existing job..."
    ${RESET_SCRIPT} --job-only
fi

# TODO - use configmap w/ old terraform files for caching
echo "Launching job..."
mkdir -p ${CONFIG_DIR}
for file_or_dir in "$@"; do
    if [[ -d ${file_or_dir} ]]; then
        cp -R "${file_or_dir}"/. "${CONFIG_DIR}"
    else
        cp "${file_or_dir}" "${CONFIG_DIR}/"$(basename "${file_or_dir}")
    fi
done
kubectl create configmap terraform-config --from-file="${CONFIG_DIR}"
kubectl create -f ${TERRAFORM_APPLY_JOB}
../utils/wait-for-job.sh terraform-apply
echo "Job completed..."
