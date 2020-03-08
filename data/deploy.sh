#!/bin/bash

# No error accepted
set -eu

# Load OpenStack parameters
if [ ! -f ~/data/openrc.sh ]; then
    echo "Please copy your Openstack RC file into the data directory"
    exit 1
fi
. ~/data/openrc.sh

# Load ANSIBLE Playbook for HortonWorks
if [ -d ~/ansible-hortonworks ]; then
    cd ~/ansible-hortonworks/
    git pull
    cd ..
else
    git clone https://github.com/julienbayle/ansible-hortonworks.git ~/ansible-hortonworks
fi

# Add our SSH key to Openstack nova keypairs
KEY_COUNT=`nova keypair-list | grep id_ovh_cloud | wc -l`
if [ "$KEY_COUNT" != "1" ]; then
    nova keypair-add --pub-key ~/.ssh/id_ovh_cloud.pub id_ovh_cloud
fi

# Configure 
export CLOUD_TO_USE=openstack
if [ -f ~/data/cloud_config ]; then
    cp ~/data/cloud_config ~/ansible-hortonworks/inventory/openstack/group_vars/all
fi
if [ -f ~/data/hortonworks_config ]; then
    cp ~/data/hortonworks_config ~/ansible-hortonworks/playbooks/group_vars/all
fi

# Create servers (Uses cloud_config parameters)
cd ~/ansible-hortonworks
./build_cloud.sh 

# Install HortonWorks ambari and configure the server (Uses hortonworks_config parameters)
cd ~/ansible-hortonworks
./install_cluster.sh