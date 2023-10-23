Fast/cheap/correct way to create or destroy many Virtual Machines on any/one KVM-enabled host in a manner similar to cloud bootstrap.
If you still do not have a test cluster or you have a problems with its debugging, you are in a right place.

See INSTALL.md for system requirements and install guide.

Why:

  - Firstly this repo was made to simplify the debugging clusters, such as Kubernetes.
  - Secondly to understand how to make terraform scalable with a large number of providers and modules.
  - Thirdly to find out how Terraform can use Libvirt to control KVM resources, as if a KVM is a cloud provider.
  - Finally using other not full virtualization methods such as docker containers or "refabrished" kubernetes,
    with a less isolation of kernel/configuration/network stack, will lead to the fact that you will debug these "emulators"
    instead of k8s itself and a number of questions will be unsolvable:
      - how to deploy a production k8s cluster and what requirements it will have for hardware/programs/OS settings?
      - what important restrictions and default values are present in the "emulator", why it matter, how to transfer them to a production cluster?
      - what successful actions of yours "emulator" will lead to increased load or failures on the production cluster?
      - is the error you found in "emulator" is a k8s error or an "emulator" error?
      - what to do with errors encountered in production that cannot be reproduced on the "emulator"?
