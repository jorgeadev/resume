#!/usr/bin/env bash

job_name="$1"

until kubectl get jobs "${job_name}" -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}' | grep True > /dev/null ; do
    sleep 10;
done
