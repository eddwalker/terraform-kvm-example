#!/usr/bin/env bash
# This script caching a downloaded file. Used to terraform debugging.

set -e

PROJECT_DIR=$(pwd)
SRC="$1"
DST="$2"
CRC="$3"

code=0

mkdir -p "$DST%/*"

printf "%s\n" "pwd: $PROJECT_DIR/"
printf "%s\n" "src: $SRC"
printf "%s\n" "dsr: $DST"

if [ -z "$1" ]
then
    printf "%s\n" "Error: download URL must be specified"
    exit 1
fi

if [ -z "$2" ]
then
    printf "%s\n" "Error: download URL must be specified"
    exit 1
fi

if [[ -f "$DST" ]]
then
    printf "%s\n" "file already downloaded"
else
    printf "%s\n" "start downloading"
    set +e
    out="$(curl -C - --retry 4 -o "$DST" "$SRC")"
    code=$?
    set -e
fi

if [[ $code -ne 0 ]]
then
    printf "%s\n" "Error: failed curl execution with exit code $code: $out"
    rm -f "$DST"
    exit 1
fi

printf "%s\n" "crc in terraform config: $CRC"

set +e
out="$(sha256sum --binary "$DST" 2>&1)"
code=$?
set -e
printf "%s\n" "crc of downloaded file:  ${out%% *}"

if [[ $code -ne 0 ]]
then
    printf "%s\n" "Error:" "failed sha256 CRC check with exit code $code: $out"
    exit 1
fi

if [[ ! -n "$CRC" ]]
then
    printf "%s\n" "crc check will be skipped since sha256sum is absent or empty in terraform config"
    exit 0
fi

if [[ ! "${out%% *}" == "$CRC" ]]
then
    printf "%s\n" "Error: crc mismatch between downloaded file and terraform config: ${out%% *} vs $CRC"
    exit 1
else
    printf "%s\n" "crc match between downloaded file and terraform config"
fi
