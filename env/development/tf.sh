#!/usr/bin/env bash
# Note this script required to run init.sh first

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

../../sh/terraform/tf.sh "$@"
