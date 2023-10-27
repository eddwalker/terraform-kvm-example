terraform {
  required_version = "~> 1.5.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
      # note: 0.7.4 try to use qemu-guest-agent to retrieve domain (vm) address
      #       in the moment of create vm, so detect will always fail, since os not started yes
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Untested:
# export LIBVIRT_DEFAULT_URI="qemu+ssh://root@192.168.1.100/system"
# export LIBVIRT_DEFAULT_URI="qemu:///system"

