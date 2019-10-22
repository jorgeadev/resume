#!/usr/bin/env bash

for host_ip_pair in "$@"; do
    arrIN=(${host_ip_pair//=/ })
    url_to_add="${arrIN[0]}"
    host_ip="${arrIN[1]}"

    grep -q "${url_to_add}" /etc/hosts && sudo sed -i "/${url_to_add}/c\\${host_ip}\t${url_to_add}" /etc/hosts || sudo echo -e "${host_ip}\t${url_to_add}" >> /etc/hosts
done

