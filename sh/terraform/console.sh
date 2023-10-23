#!/usr/bin/env bash

set -e

# Goto to module dir or terraform will fail with alot of weird errors
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $script_dir

sudo bash -c "terraform console"
