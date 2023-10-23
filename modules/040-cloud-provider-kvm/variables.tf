terraform {
  required_version = "~> 1.5.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Untested:
# export LIBVIRT_DEFAULT_URI="qemu+ssh://root@192.168.1.100/system"
# export LIBVIRT_DEFAULT_URI="qemu:///system"

