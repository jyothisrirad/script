#!/bin/bash

### 
. /home/sita/script/minecraft/alias.minecraft

### 
addto_root_crontab() {
	su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
s65
mcserver restore

sudo rm /etc/logrotate.d/bungeecord
sudo ln -s /mnt/runtimes/65-bungeeCord-azure/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord-azure/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord

~/script/init.d/inst.as.sh ~/script/init.d/bungee.d bungeestart

addto_root_crontab "0 23 * * * /sbin/poweroff"
