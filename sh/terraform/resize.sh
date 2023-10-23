
set -e

if [[ ! -n $1 ]]
then
    echo params required: vm_name add_gb_to_disk:
    echo example: controller_1 1.5G
    exit 1
fi

name=$1
inc=$2

img=$(sudo virsh domblklist "$name" | grep -oP '\K[^\s]+.qcow2')
img="/opt/terraform/kubernetes1-images/$img"
echo "img=$img"
sudo virsh shutdown  $name || true
sudo qemu-img resize $img +${inc}
sudo virsh start     $name
