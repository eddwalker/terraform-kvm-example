#!/usr/bin/env bash
# Deliver changes from remote to local tfstate
# Run ./show_changes to see remote changes

# Notes:
# - this also will be refresh all data sources
#   https://spacelift.io/blog/terraform-data-sources-how-they-are-utilised

sudo terraform refresh
