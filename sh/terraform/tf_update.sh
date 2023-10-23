#!/usr/bin/env bash

set -e

url=https://developer.hashicorp.com/terraform/downloads
tmp=/tmp/terraform_update
dst=/usr/local/sbin

outdated="$(terraform -version -json | grep -oP 'terraform_outdated.*:\s*\K.*')"

terraform -version -json

if [[ "$outdated" == "true" ]]
then
    echo need update..
else
    echo update not required.
    exit 0
fi

echo create temp dir ..
rm -fR    $tmp
mkdir -p $tmp
cd       $tmp

echo get $url ..
out="$(curl -sL $url 2>&1)"

echo parse page to find zip ..
zip="$(echo "$out" | grep -oP 'href="\Khttps://releases[a-z0-9._:/-]+' | grep -m1 "linux.*amd64.*zip$")"

echo found release zip: $zip
curl -o new.zip -L $zip

echo list downloaded files in $tmp
ls -la

echo extracting to temp dir $tmp ..
unzip -d   ./extracted/ new.zip

echo list extracted in $tmp/extracted/
ls -la ./extracted/

echo move extracted to $dst
sudo cp -v ./extracted/* $dst/

echo Clean up
cd /
rm -Rf $tmp
