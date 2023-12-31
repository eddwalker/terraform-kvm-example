# This file consist variables defaults for whole infrastructure
# All below variables must be also in output "values"
# Note all root variables from this file must be added to output.
# Note '_variable' is special variables for debug only, do not use they.

locals {
  values = {
      vms_default_mandatory_keys = {
	  host_name     = "autohostname"
          cpu_cores     = 2
	  ram_megabytes = 1724
          disk_bytes    = 4294967296
      }
      vms = {
         controller_1_default = {
	    hostname      = "controller-1-default"
            cpu_cores     = 2
	    ram_megabytes = 1724
            disk_bytes    = 4294967296
	 }
      }
      os_image_src         = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
      #os_image_src        = "https://cdn.sstatic.net/Img/teams/teams-illo-free-sidebar-promo.svg?v=47faa659a05e"
      os_image_dst         = "/opt/terraform/image_cache/ubuntu-18.04-server-cloudimg-amd64.qcow2"
      os_image_format      = "qcow2"
      os_image_sha256sum   = "" # empty value means skip checksum verify
      # os_image_sha256sum = "8dd2e6b5e5aad20c3f836123b300cba9861249408cbb07c359145a65d6bab6b6"
      net_domain           = "vm.local"
      net_cidr             = "10.10.10.0/24"
      net_name             = "vm_network"
      net_mode             = "nat"
      pool_dir             = "/opt/terraform/kubernetes1-images"
      pool_name            = "vm_pool"
      #host_prefix          = "vm"
      # The latest version of Libvirt requires that the Guemu-Guest-Agent installs as soon as possible
      # after setup VM or failing with an error, like: couldn't retrieve IP address of domain id: ..
      apt_update           = true
      apt_upgrade          = false
      user_name            = "developer"
      # below password 'pass' created with: mkpasswd --method=SHA-512 --rounds=4096
      user_pass            = "$6$rounds=4096$4jmONvw5ebmhmRFd$JdhstXO6qRIYtrxikhnnIUbMc9Bv3Zr1e/B8W4uvuutrNc8ldgjXgEZs35gkQ3rTS4ui3.fPFeLKtKQhvrZxG1"
      user_pass_lock       = false    # true will disable password login
      user_pubkeys         = ["ssh-rsa ... description", ]
  }
}

output "values" {
  value = local.values
}

