#!/bin/bash

### 
addto_root_crontab() {
	su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
addto_root_crontab "0 23 * * * /sbin/poweroff"
~/script/init.d/inst.as.sh ~/script/init.d/bungee.d bungeestart

### 
. /home/sita/script/minecraft/alias.minecraft

### 
s65
mcserver restore

sudo rm /etc/logrotate.d/bungeecord
sudo ln -s /mnt/runtimes/65-bungeeCord-azure/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord-azure/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord
