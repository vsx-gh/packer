#!/bin/bash

################################################################################
# Script:     install_packer.sh
# Author:     Jeff VanSickle
# Created:    20171103
#
# Script installs Packer imaging/packaging tool
################################################################################

show_usage() {
  echo -e "Usage: $0 [version_number]\n"
  exit -1
}

clean_tmp() {
  for fname in $(echo 'packer_"$packer_ver"_SHA256SUMS.sig packer_"$packer_ver"_SHA256SUMS.sig packer_"$packer_ver"_SHA256SUMS.sig' | tr " ", "\n")
    do 
      if [ -f $fname ]; then
        rm /tmp/$fname
      fi
    done
}

if [ $# -lt 1 ]; then
  show_usage
fi

packer_ver="$1"
sys_arch=$(uname -s | tr '[[:upper:]]' '[[:lower:]]')

# Check if Packer installed
if [ -f $HOME/.local/bin/packer ]; then
  packer_installed_ver=$($HOME/.local/bin/packer --version)
  echo -n "Packer already installed and/or newer than $packer_ver. Want to replace? (Y/N): "
  read replace_ver
  replace_ver=$(echo "$replace_ver" | tr '[[:lower:]]' '[[:upper:]]')

  while [ "$replace_ver" != "Y" -a "$replace_ver" != "N" ]
    do
      echo -n "Packer already installed and/or newer than $packer_ver. Want to replace? (Y/N): "
      read replace_ver
      replace_ver=$(echo "$replace_ver" | tr '[[:lower:]]' '[[:upper:]]')
    done

  # Don't replace installed version
  if [ "$replace_ver" == "N" ]; then
    echo -e "Choosing not to replace Packer v"$packer_installed_ver". Exiting....\n"
    exit 0
  fi
fi

# Packer not installed. Let's go get it.
# See if we have wget - Macs don't have it by default
cd /tmp
if [ $(which wget) != "" ]; then
  wget https://releases.hashicorp.com/packer/"$packer_ver"/packer_"$packer_ver"_SHA256SUMS
  wget https://releases.hashicorp.com/packer/"$packer_ver"/packer_"$packer_ver"_SHA256SUMS.sig
else
  curl https://releases.hashicorp.com/packer/"$packer_ver"/packer_"$packer_ver"_SHA256SUMS -o packer_"$packer_ver"_SHA256SUMS 
  curl https://releases.hashicorp.com/packer/"$packer_ver"/packer_"$packer_ver"_SHA256SUMS.sig -o packer_"$packer_ver"_SHA256SUMS.sig 
fi

# Check if GPG is available for verifying the sums file
if [ $(which gpg) == "" ]; then
  echo "No GPG installed to verify checksums. Exiting...."
  clean_tmp
  exit -1
fi

# Verify checksums file
echo -e "Verifying checksums file....\n"
gpg --verify /tmp/packer_"$packer_ver"_SHA256SUMS.sig /tmp/packer_"$packer_ver"_SHA256SUMS
echo -n "Please examine gpg output and look for 'Good signature'. Continue (Y/N): "
read keep_going
keep_going=$(echo $keep_going | tr '[[:lower:]]' '[[:upper:]]')

while [ "$keep_going" != "Y" -a "$keep_going" != "N" ]
  do 
    echo -n "Please examine gpg output and look for 'Good signature'. Continue (Y/N): "
    read keep_going
    keep_going=$(echo $keep_going | tr '[[:lower:]]' '[[:upper:]]')
  done

if [ "$keep_going" == "N" ]; then
  echo -e "Exiting by user input....\n"
  clean_tmp
  exit 0
fi

# Check if we're dealing with systems we can manage
if [ ! "$sys_arch" == "darwin" -a ! "$sys_arch" == "linux" ]; then 
  echo "System architecture not found. Please visit https://packer.io/downloads.html"
  exit -1
fi

# Grab binary, verify, and install
echo -e "Getting Packer binary....\n"
wget https://releases.hashicorp.com/packer/"$packer_ver"/packer_"$packer_ver"_"$sys_arch"_amd64.zip

echo -e "Checking binary checksum....\n"
sum_status=$(grep $(shasum -a 256 /tmp/packer_"$packer_ver"_"$sys_arch"_amd64.zip) /tmp/packer_"$packer_ver"_SHA256SUMS) 
if [ "$sum_status" == "" ]; then
  echo -e "Checksum not found in checksums file. Exiting....\n"
  clean_tmp
  exit -1
fi

sleep 3

# Unzip to /usr/local/bin
echo -e "Placing Packer binary into execution path....\n"
unzip -d $HOME/.local/bin /tmp/packer_"$packer_ver"_"$sys_arch"_amd64.zip

sleep 3

# Test packer to make sure it works
echo -e "Running Packer to make sure it works....\n"
$HOME/.local/bin/packer

# Clean up files if haven't already by early exits
clean_tmp
