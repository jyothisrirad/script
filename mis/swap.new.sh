#!/bin/bash

swapsize=$(grep MemTotal /proc/meminfo | awk '{print $2 }' | xargs -I {} echo "sqrt({}/1024^2)" | bc)

addto_fstab() {
	fsfile=/etc/fstab

	if ! sudo grep -Fxq "$*" $fsfile; then
		echo $* | sudo tee -a $fsfile
	fi
}

delfrom_fstab() {
	sudo sed -i "/$1/d" /etc/fstab
}

echo sudo fallocate -l $swapsizeG /swapfile
exit 
sudo swapon --show
sudo swapoff -a
#delete swap from fstab
delfrom_fstab swap
echo sudo fallocate -l $swapsizeG /swapfile
exit 
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
addto_fstab /swapfile none swap sw 0 0
sudo swapon --show

#server
echo swappiness
cat /proc/sys/vm/swappiness
echo vfs_cache_pressure
cat /proc/sys/vm/vfs_cache_pressure
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf


#desktop
cat /proc/sys/vm/swappiness
cat /proc/sys/vm/vfs_cache_pressure
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

