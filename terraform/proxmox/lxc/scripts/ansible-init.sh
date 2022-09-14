#!/bin/bash

mkdir -p /home/ansible/.ssh
groupadd -g 5000 ansible
useradd -s /bin/bash -u 5000 -g ansible -d /home/ansible -c "Ansible User" ansible
chown -R ansible:ansible /home/ansible
chmod 700 /home/ansible
ssh-keygen -f /home/ansible/.ssh/id_rsa -t rsa -N '' -q
echo "" > /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh/*;chmod 600 /home/ansible/.ssh/authorized_keys
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-ansible
echo "Set disable_coredump false" >> /etc/sudo.conf
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible -y
