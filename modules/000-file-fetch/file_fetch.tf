variable "settings" {}

####data "external" "validateem" {
####    count = ( var.settings.os_image_src == null ) ? 1 : 0
####    program = [ "Error: a message that indicates the error" ]
####}


#check "health_check" {
#  # null here for protect from 'Changes to Outputs'
# #  data "var.settings" "this" {
# #  }
#  assert {
#    condition     = alltrue([
#        var.settings.libvirt.vm.os_image_src == null,
#    ])
#    error_message = "Undefined variable"
#  }
#}


resource "null_resource" "file_absent" {
  triggers = {
    file_fetch_required = fileexists(var.settings.os_image_dst) ? false : true
  }
}

## Download OS base image save, explicit and keep it
resource "null_resource" "file_fetch" {

  lifecycle {
    replace_triggered_by = [
      null_resource.file_absent
    ]
  }

  provisioner "local-exec" {
    when       = create
    on_failure = fail
    #   working_dir = path.module # must not use here. or paths will be brake
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/scripts/get_file.sh \"${var.settings.os_image_src}\" \"${var.settings.os_image_dst}\" \"${var.settings.os_image_sha256sum}\""
  }
}

output "values" {
  # value = var.settings
  value = {
    #_fetch_file_settings_inherited  = var.settings
    _path_module                = path.module
    _file_fetch_required        = null_resource.file_absent.triggers.file_fetch_required
    _notes                      = "file_fetch_required after every success file download will be ='true', but it stay 'true' till next apply - it is FIXME"
    "null_resource_file_absent" = null_resource.file_absent
    "null_resource_file_fetch"  = null_resource.file_fetch
  }
}
