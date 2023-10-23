#!/usr/bin/env bash
# This script download all providers versions declared
# in all modules of this environment.
# Start from environment dir. i.e.: cd ./development/ && ../sh/download.sh

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/variables.inc

echo PLUGIN_DIR=$PLUGIN_DIR
echo WORK_DIR=$WORK_DIR
echo PROVIDER_DIR=$PROVIDER_DIR

mkdir -p $PLUGIN_DIR

TMP_DIR=/tmp/providers_temp
rm -Rf $TMP_DIR
mkdir  $TMP_DIR

echo "List modules and providers.."
echo "-----------------------------------------------------------------"
echo "| Mode | Module             | Provider"
echo "-----------------------------------------------------------------"

cd $WORK_DIR/../../modules/
for i in *
do
#  echo "Module: $i"
  cd $WORK_DIR/../../modules/$i
  platform="$(terraform -v | grep -oP "^on\s*\K.*")"
  module_paths="$(terraform providers | awk -F'[]|[]| ' '/provider\[/{print $3"/"$5}')"

  if [[ ! -n $module_paths ]]
  then
      printf "  %-6s %-20s %s\n" "skip" "$i" "none"
      continue
  fi

  for m in $module_paths
  do
    if [[ -d $PROVIDER_DIR/$m/$platform ]]
    then
      printf "  %-6s %-20s %s\n" "skip" "$i" "$m/$platform"
    else
      printf "  %-6s %-20s %s\n" "down" "$i" "$m/$platform"
      echo "    set -e
      echo '  'down $i ..
      mkdir -p "$TMP_DIR/$i"
      cd $TMP_DIR/$i
      terraform init \
        -from-module=$WORK_DIR/../../modules/$i \
        -get=true \
        -input=false \
	-backend=false \
	2>&1
      " > "$TMP_DIR/$i.sh"
      chmod +x "$TMP_DIR/$i.sh"
    fi
  done
done

echo "Envoking parallel download .."

for i in $TMP_DIR/*
do
    [[ ! $i =~ \.sh$ ]] && continue
    out="$($i &)"
    echo "$out" | sed 's|^|    |'
done
wait

echo "Copy downloaded providers .."
cd $WORK_DIR/../../modules
for i in *
do
    [[ ! -d $TMP_DIR/$i/.terraform/ ]] && continue
    rsync \
      -arv \
      --checksum \
      $TMP_DIR/$i/.terraform/ \
      $PLUGIN_DIR/.terraform/
done

echo DONE

# find $TMP_DIR ! -type d

