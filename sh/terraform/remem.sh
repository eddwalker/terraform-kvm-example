
host=$1
mem=$2
# mem in K

sudo virsh setmaxmem $1 $2 --config
sudo virsh setmem    $1 $2 --config
sudo virsh shutdown  $1
sudo virsh start     $1
