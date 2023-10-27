sudo virsh list --all
# not work vs dhcp in last kvm: sudo virsh net-dhcp-leases vm_network

for i in $(sudo virsh list --id)
do
    sudo virsh domname    --domain $i | grep -vE '^( Name|---)' | sed 's|$|   |' | tr -d '\n'
    sudo virsh domifaddr  --domain $i | grep -vE '^( Name|---)'
done

