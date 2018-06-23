#!/bin/bash

### 
addto_root_crontab() {
	! sudo crontab -l | grep -Fxq "$*" && su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
addto_root_crontab "# reboot daily"
# addto_root_crontab "0 23 * * * /sbin/poweroff"
addto_root_crontab "0 23 * * * /sbin/shutdown -h now"
~/script/init.d/inst.as.sh ~/script/init.d/start.mc.d startmc

### 
~/script/minecraft/gcloud/init.sh

[ ! -f ~/script/init.d/hosts/$(hostname) ] && cp ~/script/init.d/hosts/default ~/script/init.d/hosts/$(hostname)

### 
# sudo mkdir /mnt/backup/74-UHC
# sudo chown sita:sita /mnt/backup/74-UHC
gcsfuse --key-file /home/sita/.gcloud/chsliu@gmail.com.json creeper-tw-backup /mnt/backup

### 
. /home/sita/script/minecraft/alias.minecraft
s65
mcserver restore

### 
# echo !!!!!!!!!!!!!!
# echo vi start.mc.sh
# echo 65
# echo mcrestore
# echo !!!!!!!!!!!!!!

### 
/mnt/runtimes/65-bungeeCord-azure/update.sh
/mnt/runtimes/65-bungeeCord-azure/update.sh
/mnt/runtimes/65-bungeeCord-azure/update.sh

sudo rm /etc/logrotate.d/bungeecord
sudo ln -s /mnt/runtimes/65-bungeeCord-azure/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord-azure/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord

### 
gcloud auth login

### 
# echo !!!!!!!!!!!!!!
# echo vi ~/start.mc.sh
# echo vi /mnt/runtimes/65-bungeeCord-azure/plugins/RedisBungee/config.yml
# echo !!!!!!!!!!!!!!
