Hortonworks Data Platform provisonning using Ansible (Ambari / Blueprints), OpenStack and Docker
==========

Purpose
-------

This project provides a Docker image to easily install the Hortonworks Data Platform. The sample configuration file and the following steps have been tested with success with OVH public cloud openstack infrastructure provider.

> This project is for personnal and temporary tests purpose (Firewall is disabled, no private network, no storage persistance, no backups, built on a fork of the official hortonworks ansible playbooks, ...)

Installation steps
-----

1. Clone this repository `git clone https://github.com/julienbayle/hortonworks`
2. Create a new "Public cloud project" using the [OVH Manager](https://www.ovh.com/manager/public-cloud)
3. Create a new Open Stack User with administrative priviledges
4. Download the "OpenStack RC" the user for GRA7 zone (This zone works) and save it as `data/openrc.sh`
5. (Optional) Edit `data/openrc.sh` to save your password instead of using a prompt
6. Create an SSH key for this projet `ssh-keygen -b 4096` and save it as `data/id_ovh_cloud`
7. Publish your SSH Public Key into your Public cloud project (Project Management > SSH Keys)
8. Update data/cloud_config and data/hortonworks_config files to fit your needs [Documentation](https://github.com/hortonworks/ansible-hortonworks/blob/master/INSTALL_OpenStack.md) 
9. Build your cluster using docker : `./run.sh autodeploy`
10. Wait for the process to complete (About 1 hour). When the task is "Wait for the cluster to be built", you can follow the installation progress in your browser : MASTER_IP:8080. If the service startup fails, just look at the logs for details or try to start all services again (action available in the Ambari administration menu)
11. You can drop this project when your cluster is ready or keep it for maintenance purpose ;o)

Installation requires about 12Go on slaves and 14Go on the master (disk usage). Also, the master node requires more than 10Go of RAM to start.

Enjoy your day, Big Data guys !

How to ?
------

Open the Docker tools shell:
```bash
./run.sh
```

Execute an Openstack command using the docker tools (For instance, show cluster IPs):
```bash
./run.sh "source ~/data/openrc.sh && nova list"
```

Connect to one machine into the cluster via SSH using the projet key
```bash
ssh centos@MACHINE_IP -i data/id_ovh_cloud
```

Optional steps
--------------

### Add a DNS entry for the master server

Configure an "A" entry in your DNS and [add a reverse DNS entry for the server](https://support.us.ovhcloud.com/hc/en-us/articles/360002181530-How-to-Configure-Reverse-DNS). 

Then connect to your master node using SSH :
```bash
ssh centos@MASTER_MACHINE_IP -i ~/.ssh/id_ovh_cloud
sudo vi /etc/hosts (add a YOUR_PUBLIC_IP YOUR_DOMAIN line)
sudo hostnamectl set-hostname YOUR_DOMAIN
```

What's next ?
--------

* Update ANSIBLE Playbook to define some firewall rules and openstact network (security purposes)
* Update ANSIBLE Playbook to configure DNS [OVH DND with ANSIBLE](https://github.com/gheesh/ansible-ovh-dns)
* Update ANSIBLE Playbook to use persistant storage for services

Bibliography
------------

[Openstack Cheat Sheet](https://docs.openstack.org/mitaka/user-guide/cli_cheat_sheet.html)

[Ambari documentation](https://ambari.apache.org)

[Hortonworks Ansible playbooks](https://github.com/hortonworks/ansible-hortonworks)

[Hardware requirements](https://docs.cloudera.com/documention/enterprise/release-notes/topics/hardware_requirements_guide.html)

[Memory tuning](https://docs.cloudera.com/documentation/enterprise/5/latest/topics/cm_ig_host_allocations.html)