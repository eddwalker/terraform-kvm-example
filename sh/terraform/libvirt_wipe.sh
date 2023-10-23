#!/usr/bin/env bash
# This DESTROY resources what most likely stay running while normal apply execution was failed

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# Some of next commands expected to exit with errors,
# but we cannot know which ones
#
set +e

sudo virsh net-undefine  vm_network
sudo virsh net-destroy   vm_network
sudo virsh net-undefine  vm_network

sudo virsh pool-undefine vm_pool
sudo virsh pool-destroy  vm_pool
sudo virsh pool-undefine vm_pool

sudo rm -v terraform.tfstate*

echo "Wipe done"
