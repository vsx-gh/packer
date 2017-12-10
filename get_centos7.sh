#!/bin/bash

################################################################################
# Script:     get_centos7.sh
# Author:     Jeff VanSickle
# Created:    20171103
#
# Script fetches specific CentOS 7 build ISO and verifies it. Should be run from
# inside the cloned Packer repo, as paths are relative (I hate that).
################################################################################

cd resources
echo -e "Fetching latest CentOS 7 minimal ISO to /resources....\n"
#curl http://mirrors.kernel.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso -o resources/CentOS-7-x86_64-Minimal-1708.iso 
echo -e "Finished grabbing ISO. You can proceed with Packer tasks.\n"

# wget http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
curl http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 -o RPM-GPG-KEY-CentOS-7
curl http://mirrors.kernel.org/centos/7/isos/x86_64/sha256sum.txt.asc -o sha256sum.txt.asc 
curl http://mirrors.kernel.org/centos/7/isos/x86_64/sha256sum.txt -o sha256sum.txt

# See if GPG signing works out
echo -e "\n\n"
gpg --verify sha256sum.txt.asc
echo -en "\nPlease verify output of GPG key check. Continue? (Y/N): "
read keep_going
keep_going=$(echo "$keep_going" | tr '[a-z]' '[A-Z]')

while [ "$keep_going" != "Y" -a "$keep_going" != "N" ]
  do
    echo -en "\nPlease verify output of GPG key check. Continue? (Y/N): "
    read keep_going
    keep_going=$(echo "$keep_going" | tr '[a-z]' '[A-Z]')
  done

if [ "$keep_going" == "N" ]; then
  echo -e "Exiting by user input....\n"
  exit 0
fi

# Verify checksum for ISO
echo -e "\nVerifying ISO checksum...."
sum_check=$(grep $(shasum -a 256 CentOS-7-x86_64-Minimal-1708.iso) sha256sum.txt.asc)
if [ "$sum_check" == "" ]; then
  echo -e "ISO checksum not found. Exiting....\n"
  exit -1
else
  echo -e "ISO checksum found: $sum_check\n"
fi

# Clean up
cd - > /dev/null
