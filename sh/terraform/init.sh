#!/usr/bin/env bash
# Initialize terraform providers for current project (pwd)
# This script may be run in parraller for different projects

# Notes:
# 1. This script save providers to special path $PROVIDER_DIR
#    but some configuration and symlinks saving in script working dir.
#    For more details run: find .terraform ! -type d -exec ls -la {} \+
# 2. This script does NOT download any providers itself,
#    if you changed somethere in libs providers or their versions
#    when you have to run ./sh/download.sh before run this script
#
set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/variables.inc

echo PROVIDER_DIR=$PROVIDER_DIR

mkdir -p $PROVIDER_DIR

terraform init \
  -get=true \
  -input=false \
  -backend=false \
  -plugin-dir=$PROVIDER_DIR \
  -force-copy \
  -upgrade

terraform providers

terraform validate

