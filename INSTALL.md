Requirements (more details in Install section):

  - Fedora 38 but should work on other Linux systems with minimal changes
  - Enabled Hardware Virtualization
  - KVM installed
  - SSD disk highly recommended due of parallel processing

Install:

1. You must have hardware **virtualization enabled**. If yes next command will return something:

       $ grep -E -o '(vmx|svm)' /proc/cpuinfo | sort | uniq

2. Install KVM, you **may skip virt-manager** if you ready to use only console tool **virsh**:

       $ sudo dnf -y install bridge-utils libvirt virt-install qemu-kvm libguestfs-tools libvirt-client virt-manager

   Note: the default method for starting the GUI Virt-Manager is using sudo from you current user, like:

       $ sudo virt-manager

3. **Download** correct Arch terraform binary from **https://developer.hashicorp.com/terraform/downloads**:

       $ wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip
       $ unzip terraform_1.5.5_linux_amd64.zip
       $ chmod +x ./terraform
       $ sudo mv  ./terraform /usr/local/bin/
       $ rm    terraform_1.5.5_linux_amd64.zip

   This repo was tested against terraform v1.5.5 (before license was changed)

4. **Clone this repo**:

       $ git clone https://github.com/eddwalker/terraform-libvirt.git
       $ cd terraform-libvirt/env/development

   All next commands MUST be run from this dir.

5. Check you **system have enought** resources to run sum of all **CPU, RAM, DISK** in config:

       $ $EDITOR ./environment/settings.tf

   Default values are absolute **minimum** to run some payload in k8s cluster, so do not lowering it:

       cpu_cores     = 2
       ram_megabytes = 1724
       disk_bytes    = 4294967296

   Instead of lowering a resources try to remove some nodes. For k8s start removing worker nodes.

6. **Replace PUBLIC ssh key** with you own PUBLIC key in **config**:

       $ $EDITOR ./environment/settings.tf

   Replace this:

       user_pubkeys         = [ "key1", "key2", ".." ]

   With this:

       user_pubkeys         = [ "ssh-rsa LDWGREHDEWDRW.... ", ]

7. **Init terraform and apply to KVM** from **terraform-libvirt/env/development/** dir:

       $ ./tf.sh download.sh
       $ ./tf.sh init.sh
       $ ./tf.sh apply.sh

   After apply done you should see list of created VMs and its IP-addresses.
   To ssh connect for use next line on computer with KVM:

       $ ssh -i private_key developer@vm_ip_addr
       vmhost$ sudo -i
       vmhost# id
       vmhost# 0 (root)
       vmhost# exit
       $

   Where:

       private_key - is a path and filename of key file for user_pubkeys.
       developer   - username from variable user_name of global of env/$name/environment/settings.tf
       vm_ip_addr  - ip address of VM

   If you **done with VMs** you may **destroy all** of them:

       $ ./tf.sh destroy.sh

8. While Terraform creates or updates resources, do not launch the script **show_resources.sh**.
   This will not break the process, but it will destroy the operational state on the Terraform side
   and as a result you will **NOT** see ip-addresses of created VM's. This is a restriction of Libvirt.

   In case you got such cituation try to fix it by full recreate:

        $ ./tf.sh destroy.sh
        $ ./tf.sh libvirt_wipe.sh

   If after it you got errors anyway try to remove files from **pool_dir** directory of **settings.tf**, normally is dir:

        /opt/terraform/kubernetes1-images/

   Next, perform **init.sh** and **apply.sh**, as in step 7.

