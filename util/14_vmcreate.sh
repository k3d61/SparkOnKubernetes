#!/bin/bash
# This script was made to create VMs on our 4 physical machine cluster
# This script creates VMs with static configuration, 
# TODO: read configuration from external .config file 
for i in {1..14}
do
	VM="spark_$i"
	echo "Creating $VM"
	VBoxManage createhd --filename $VM.vdi --size 40960
	VBoxManage createvm --name $VM --ostype "Linux_64" --register
	
	VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

	VBoxManage storagectl $VM --name "IDE Controller" --add ide

	VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /path/to/windows_server_2008.iso

	VBoxManage modifyvm $VM --ioapic on
	VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
	VBoxManage modifyvm $VM --memory 8192 --cpus 4
	VBoxManage modifyvm $vM --nic1 bridged --bridgeadapter enp1s0f0
done
