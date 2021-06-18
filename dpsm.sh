#!/usr/bin/env bash

# Ask which vm to clone
echo "Which vm should be cloned? (vmid)"
read -r vmid_template
echo ""

# Ask how many vm's should be deployed
echo "Please enter how many vm's to deploy"
read -r amount
echo ""

# Ask for the name of the new vm's
echo "What should the name of the vm be? Names are created as name+vmid"
read -r vm_name
echo ""

# Ask for administrator name on new vm's
echo "Please enter the administrators username for the new vm's"
read -r username
echo ""

# Ask for administrator password on new vm's
echo "Please enter the administrators password for the new vm's"
read -r password
echo ""

# While loop for asking if vm's should be started or not
continue=false
while [ $continue == false ]; do
	echo "Do you want to startup the vm's after deployment? y/n"
		read -r startup
		if [ "$startup" == Y ] || [ "$startup" == y ]; then
			continue=true
		elif [ "$startup" == N ] || [ "$startup" == n ]; then
			continue=true
	fi
done

# While loop to create all vm's
count=1
while [ $count -le $amount ]; do
	# Get next free vmid
	vmid_clone=$(pvesh get /cluster/nextid)

	# Clone new vm
	qm clone $vmid_template $vmid_clone --name $vm_name$vmid_clone
	qm set $vmid_clone --ciuser $username
	qm set $vmid_clone --cipassword $password
	qm set $vmid_clone --ipconfig0 ip=dhcp
	sleep 2
	if [ "$startup" == Y ] || [ "$startup" == y ]; then
		qm start $vmid_clone
	fi
	((count+=1))
done
echo ""

# Echo final message
echo "VM creation succeeded"