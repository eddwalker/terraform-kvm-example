#!/usr/bin/env bash
# Please read important notes:
# 1. This run Terraform plan with -refresh=false and skip checking remote objects
#     but let us get plan quickly. Run plan.sh to get plan with check all objects
#     or run AVOID check of should go through the entire infrastructure and show which changes is planned
# 2. See pkansh fior more details

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$SCRIPT_DIR/plan.sh -refresh=false

