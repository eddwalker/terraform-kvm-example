#!/usr/bin/env bash
# Terraform would attempt to revert your manual changes in infrastructure to plan/tfstate.

set -e

printf "Workspace=%s\n" "$(terraform workspace show)"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/variables.inc

echo PLAN_FILE=$PLAN_FILE

sudo bash -c "terraform plan -out=$PLAN_FILE && /usr/bin/time -f 'Done in: %Es' terraform apply $PLAN_FILE"
