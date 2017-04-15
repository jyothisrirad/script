#!/bin/bash

swapsize=$(grep MemTotal /proc/meminfo | awk '{print $2 }' | xargs -I {} echo "1+sqrt({}/1024^2)" | bc)G
swapfile=/swapfile

addto_fstab() {
	fsfile=/etc/fstab

	if ! sudo grep -Fxq "$*" $fsfile; then
		echo $* | sudo tee -a $fsfile
	fi
}

delfrom_fstab() {
	sudo sed -i "/$1/d" /etc/fstab
}

sudo swapon --show
sudo swapoff -a
#delete swap from fstab
delfrom_fstab swap
echo sudo fallocate -l $swapsize $swapfile
sudo fallocate -l $swapsize $swapfile
sudo chmod 600 $swapfile
sudo mkswap $swapfile
sudo swapon $swapfile
# echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
addto_fstab $swapfile none swap sw 0 0
sudo swapon --show

