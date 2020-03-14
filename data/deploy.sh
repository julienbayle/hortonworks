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
if [ -d ~/data/ansible-hortonworks ]; then
    cd ~/data/ansible-hortonworks/
    git pull
    cd ..
else
    git clone https://github.com/julienbayle/ansible-hortonworks.git ~/data/ansible-hortonworks
fi

# Add our SSH key to Openstack nova keypairs
KEY_COUNT=`nova keypair-list | grep id_ovh_cloud | wc -l`
if [ "$KEY_COUNT" != "1" ]; then
    nova keypair-add --pub-key ~/data/id_ovh_cloud.pub id_ovh_cloud
fi

# Configure 
export CLOUD_TO_USE=openstack
if [ -f ~/data/cloud_config ]; then
    cp ~/data/cloud_config ~/data/ansible-hortonworks/inventory/openstack/group_vars/all
fi
if [ -f ~/data/hortonworks_config ]; then
    cp ~/data/hortonworks_config ~/data/ansible-hortonworks/playbooks/group_vars/all
fi

# Generate password
# dependency: NiFi password needs to be at least 12 characters
if [ -f ~/data/password ]; then
    PASS=`cat ~/data/password`
else
    PASS=`openssl rand -base64 32 | head -c 16`
    echo $PASS > ~/data/password
fi

# Create servers (Uses cloud_config parameters)
cd ~/data/ansible-hortonworks
./build_cloud.sh --extra-vars "default_password=$PASS"

# Wait for the servers to be available by ssh (sometimes the last server is not ready yet)
sleep 5

# Install HortonWorks ambari and install the services (Uses hortonworks_config parameters)
cd ~/data/ansible-hortonworks
./install_cluster.sh --extra-vars "default_password=$PASS"