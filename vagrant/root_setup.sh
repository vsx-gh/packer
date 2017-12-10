#!/bin/bash

# Script:      root_setup.sh
# Created:     20170608
#
# Script perfoms some essential setup for provisioning VMs

sudo yum -y update
sudo yum -y groupinstall Base
sudo yum -y groupinstall "Development Tools"
sudo yum -y install screen kernel-headers epel-release tmux vim deltarpm nfs-utils wget sqlite-devel zlib-devel gcc xz-devel readline-devel bzip2-devel openssl-devel net-tools rsync kernel-devel bzip2 zlib-devel
sudo yum clean all
