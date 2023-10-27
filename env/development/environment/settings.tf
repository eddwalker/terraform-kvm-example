# Redefine global variables with project specific

module "settings" {
  source             = "../../../modules/000-settings"
}

locals {
  values = {

    user_pubkeys         = [ "key1", "key2", ".." ]

    os_image_src         = "https://cloud-images.ubuntu.com/jammy/20230929/jammy-server-cloudimg-amd64.img"
    os_image_dst         = "/opt/terraform/image_cache/ubuntu-22.04-server-cloudimg-amd64.qcow2"
    os_image_format      = "qcow2"
    os_image_sha256sum   = "" # empty value means skip checksum verify

    vms = {
      controller_0 = {
        type          = "controller"
        host_name     = "controller-0"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
      controller_1 = {
        type          = "controller"
        host_name     = "controller-1"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
      controller_2 = {
        type          = "controller"
        host_name     = "controller-2"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
      worker_0 = {
        type          = "worker"
        host_name     = "worker-0"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
      worker_1 = {
        type          = "worker"
        host_name     = "worker-1"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
      worker_2 = {
        type          = "worker"
        host_name     = "worker-2"
        cpu_cores     = 2
        ram_megabytes = 1750
        disk_bytes    = 4294967296
      }
    }
  }
}

output "values" {
  value = merge(module.settings.values,local.values)
}
