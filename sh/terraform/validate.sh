#!/usr/bin/env bash

set -e

# Goto to module dir or teraform will fail with alot of weird errors
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $script_dir

#terraform fmt --diff -write=false
terraform fmt
terraform validate

