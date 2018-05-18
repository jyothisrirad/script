#!/bin/bash

### 
addto_root_crontab() {
	! sudo crontab -l | grep -Fxq "$*" && su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
# addto_root_crontab "0 23 * * * /sbin/poweroff"
addto_root_crontab "0 23 * * * /sbin/shutdown -h now"
~/script/init.d/inst.as.sh ~/script/init.d/start.mc.d startmc

### 
~/script/minecraft/gcloud/init.sh

[ ! -f ~/start.mc.sh ] && cp ~/script/init.d/start.mc.uhc.sh ~/start.mc.sh

### 
# sudo mkdir /mnt/backup/74-UHC
# sudo chown sita:sita /mnt/backup/74-UHC
gcsfuse --key-file /home/sita/.gcloud/chsliu@gmail.com.json creeper-tw-backup /mnt/backup

### 
. /home/sita/script/minecraft/alias.minecraft
s74
mcserver restore

### 
gcloud auth login

### 
echo !!!!!!!!!!!!!!
echo vi ~/start.mc.sh
# echo 74
# echo mcrestore
echo !!!!!!!!!!!!!!
