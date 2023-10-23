# Input varibles

variable settings {}
variable file_fetch {}

resource "libvirt_pool" "ubuntu" {
  # Hint terraform to load a necessary dependence without using last resort Meta-Argument 'depends_on'
  name = var.file_fetch.null_resource_file_fetch.id == null ? null : var.settings.pool_name
  path = var.settings.pool_dir
  type = "dir"

  #lifecycle {
  #  ignore_changes = [
  #    allocation,
  #    available,
  #    capacity,
  #  ]
  #}
}

resource "libvirt_volume" "os_image_ubuntu" {
  name           = "os_image_ubuntu_default.qcow2"
  pool           = libvirt_pool.ubuntu.name
  source         = var.settings.os_image_dst
}

resource "libvirt_volume" "ubuntu_qcow2" {
  for_each       = var.settings.vms
  format         = var.settings.os_image_format
  name           = "${each.key}_volume.${var.settings.os_image_format}"
  pool           = libvirt_pool.ubuntu.name
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  size           = each.value.disk_bytes
}

resource "libvirt_network" "vm_public_network" {
  # Hint terraform to load a necessary dependence without using last resort Meta-Argument 'depends_on'
  name      = var.file_fetch.null_resource_file_fetch.id == null ? null : var.settings.net_name
  mode      = var.settings.net_mode
  domain    = var.settings.net_domain
  addresses = ["${var.settings.net_cidr}"]
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each       = var.settings.vms
  name           = "${each.key}_cloudinit.iso"
  pool           = libvirt_pool.ubuntu.name
  network_config = templatefile("${path.module}/templates/network_config.cfg", {
  })
  user_data = templatefile("${path.module}/templates/cloud_init.cfg", {
    VM_HOST_NAME     = "${each.value.host_name}"
    VM_HOST_FULLNAME = "${each.value.host_name}.${var.settings.net_domain}"
    VM_USER_NAME     = var.settings.user_name
    VM_USER_PUBKEYS  = var.settings.user_pubkeys
    VM_APT_UPDATE    = var.settings.apt_update
    VM_APT_UPGRADE   = var.settings.apt_upgrade
  })
}

resource "random_string" "vm-name" {
  length = 6
  upper  = false
  #number = false
  lower   = true
  special = false
}

resource "libvirt_domain" "domain" {

  for_each   = var.settings.vms

  lifecycle {
    ignore_changes = [
      # cmdline,
    ]
  }

  name       = each.value.host_name
  memory     = each.value.ram_megabytes
  vcpu       = each.value.cpu_cores
  qemu_agent = true

  # disk     = disk resize available only in cloudinit
  cloudinit  = libvirt_cloudinit_disk.cloudinit[each.key].id

  network_interface {
    network_id     = libvirt_network.vm_public_network.id
    network_name   = libvirt_network.vm_public_network.name
    hostname       = each.value.host_name
    wait_for_lease = true  #  makes apply fail save
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2[each.key].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}

# Generate inventory file for Ansible
resource "local_file" "ansible_inventory_hosts" {

  #filename = "../ansible/inventory/hosts.cfg"
  file_permission = 0644
  filename = "${path.root}/environment/hosts.cfg"
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      allnodes = [
        for name in keys(libvirt_domain.domain) :
          join(""
            , [ var.settings.vms[name].host_name ]
	    , [ " ansible_host=" ]
	    , libvirt_domain.domain[name].network_interface[*].addresses[0]
          )
      ]
      masters = [
        for name in keys(libvirt_domain.domain) :
          join(""
	    , [ var.settings.vms[name].host_name ]
	    , [ "" ]
          )
          if var.settings.vms[name].type == "controller"
      ]
      workers = [
        for name in keys(libvirt_domain.domain) :
          join(""
             , [ var.settings.vms[name].host_name ]
	     , [ "" ]
          )
          if var.settings.vms[name].type == "worker"
      ]
      #worker_hosts = [
      #  for name in keys(libvirt_domain.domain) :
      #       lookup(var.settings.vms[name].host_name, join("", libvirt_domain.domain[name].network_interface[*].addresses[0]))
      #       #object=name
      #       #type=var.settings.vms[name].type
      #       #host_name = var.settings.vms[name].host_name
      #       #addresses =  join("", libvirt_domain.domain[name].network_interface[*].addresses[0])
      #]
    }
  )
}

output "validate" {
  # null here for protect from 'Changes to Outputs'
  value = null
  precondition {
    condition     = alltrue([
        var.settings.os_image_dst != null,
    ])
    error_message = "Undefined variable"
  }
}

output "values" {
  value = {
    #_libvirt_inherited_settings         = var.settings
    _libvirt_inherited_filefetch_id      = var.file_fetch.null_resource_file_fetch.id
    _net_cidr_from_settings              = var.settings.net_cidr
    _path_module                         = path.module
    "random_string__vm-name"              = random_string.vm-name
    "libvirt_pool__ubuntu"                = libvirt_pool.ubuntu
    "libvirt_volume__os_image_ubuntu"     = libvirt_volume.os_image_ubuntu
    "libvirt_volume__ubuntu_qcow2"        = libvirt_volume.ubuntu_qcow2
    "libvirt_network__vm_public_network"  = libvirt_network.vm_public_network
    "libvirt_cloudinit_disk__cloudinit"   = libvirt_cloudinit_disk.cloudinit
    "libvirt_domain__domain"              = libvirt_domain.domain

#    x_test                              = [ for ip in libvirt_domain.domain[*].controller_0.network_interface[*].addresses[0]  : "${ip}" ]
#    x_test2                             = flatten([ for name in keys(libvirt_domain.domain) :
#                                               {
#                                                 object=name
#                                                 type=var.settings.vms[name].type
#					         host_name=var.settings.vms[name].host_name
#                                                 addresses=join("", libvirt_domain.domain[name].network_interface[*].addresses[0])
#					       }
#					    ])

  }
}
