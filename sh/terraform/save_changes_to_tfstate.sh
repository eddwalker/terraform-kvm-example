#!/usr/bin/env bash
# Terraform would change tfstate to infrastructure, but will not change infrastructure

set -e

sudo bash -c "terraform apply -refresh-only"
