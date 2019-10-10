# Ansible Base Server Role

#### This Ansible Role is for provisioning a rhel, centos, or ubuntu instance to a base configuration. This role performs the following tasks:

* Deploys Packages needed for AD/LDAP Integration

* Configures SSSD and PAM for SSO

* Deploys SSH Pub-Keys for DevOps and SysAdmins

* Configures SSH Daemon to only allow ssh-pubkey authentication

* Deploys and Configures Prometheus Monitoring Agents

* Deploys and Configures FileBeats for Kibana/Elasticsearch SEIM Management
