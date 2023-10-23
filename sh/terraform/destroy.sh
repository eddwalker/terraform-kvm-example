#!/usr/bin/env bash
# This destroy remote configuration
# Notes:
# 1. If you run destroy after unsucessful apply.sh some configuration parts may be detected
#    at least for libvirt, so try wipe hard with sh/libvirt_wipe.sh,
#    to stateless destroy libvirt virtual networks and machines created by terraform earlier

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/variables.inc

sudo bash -c "/usr/bin/time -f 'Done in: %Es' terraform destroy -auto-approve"
