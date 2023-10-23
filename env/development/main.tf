
module "settings" {
  source           = "./environment/"
}

module "file_fetch" {
  source   = "../../modules/000-file-fetch"
  settings = module.settings.values
}

module "libvirt" {
  source     = "../../modules/040-cloud-provider-kvm"
  settings   = module.settings.values
  file_fetch = module.file_fetch.values
}

output module_root_values {
  value = {
    main_1_module_settings   = module.settings.values
    main_2_module_file_fetch = module.file_fetch.values
    main_3_module_libvirt    = module.libvirt.values
  }
}

