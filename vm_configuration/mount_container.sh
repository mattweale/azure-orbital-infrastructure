#!/bin/bash

#	=============================
#	NFS Mount Container
#	=============================

#	Check Linux Distro for nfs utils install
    source /etc/os-release
    if [ "$NAME" = "CentOS Linux" ]; then
	    echo "Found RHEL Distro installing using yum"
        sudo yum install nfs-utils
    elif [ "$NAME" = "Ubuntu" ]; then
	    echo "echo Found Ubuntu Distro installing using apt"
        sudo apt install nfs-common
    else
        echo "What OS are you running!?"
    fi

#   Check VM Role to Mount right Container

    sudo mkdir -p /nfsdata

    if [ "$HOSTNAME" = "vm-orbital-data-collection" ]; then
	    echo "Found Data Collection VM mounting /saorbital/raw-data"
        sudo mount -o sec=sys,vers=3,nolock,proto=tcp saorbital.blob.core.windows.net:/saorbital/shared  /nfsdata
    elif [ "$HOSTNAME" = "vm-orbital-rtstps" ]; then
	    echo "Found RT-STPS VM mounting /saorbital/rt-stps"
        sudo mount -o sec=sys,vers=3,nolock,proto=tcp saorbital.blob.core.windows.net:/saorbital/shared  /nfsdata
    elif [ "$HOSTNAME" = "vm-orbital-ipopp" ]; then
	    echo "Found IPOPP VM mounting /saorbital/ipopp"
        sudo mount -o sec=sys,vers=3,nolock,proto=tcp saorbital.blob.core.windows.net:/saorbital/shared  /nfsdata
        cd /nfsd
    else
        echo "What VM is this!?"
    fi

sudo chmod -R 777 /nfsdata

    #    [ "$NAME" = "Ubuntu" ]; echo $?
    #    [ "$NAME" = "CentOS Linux" ]; echo $?