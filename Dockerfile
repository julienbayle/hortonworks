FROM centos:7
MAINTAINER Julien BAYLE

# Install mandatory tools (https://github.com/hortonworks/ansible-hortonworks/blob/master/INSTALL_OpenStack.m)
RUN yum -y install epel-release && yum clean all
RUN yum -y install git gcc gcc-c++ python-virtualenv python-pip python-devel libffi-devel openssl-devel libyaml-devel sshpass git vim-enhanced && yum clean all

RUN pip install pip --upgrade
RUN pip install setuptools --upgrade --ignore-installed PyYAML
RUN pip install ansible openstacksdk python-novaclient python-openstackclient --ignore-installed ipaddress

WORKDIR /root