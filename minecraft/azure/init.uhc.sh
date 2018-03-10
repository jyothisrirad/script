#!/bin/bash

### 
addto_root_crontab() {
	su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
addto_root_crontab "0 23 * * * /sbin/poweroff"
~/script/init.d/inst.as.sh ~/script/init.d/start.mc.d startmc

### 
~/script/minecraft/azure/init.sh
sudo mkdir /mnt/backup/74-UHC
sudo chown sita:sita /mnt/backup/74-UHC
cp ~/script/init.d/start.mc.sh ~/

echo !!!!!!!!!!!!!!
echo vi start.mc.sh
echo 74
echo mcrestore
echo !!!!!!!!!!!!!!

### 
# . /home/sita/script/minecraft/alias.minecraft

### 
# s74
# mcserver restore
