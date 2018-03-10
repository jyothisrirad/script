#!/bin/bash

### 
addto_root_crontab() {
	su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
addto_root_crontab "0 23 * * * /sbin/poweroff"
~/script/init.d/inst.as.sh ~/script/init.d/start.mc.d startmc

### 
# . /home/sita/script/minecraft/alias.minecraft

### 
# s74
# mcserver restore
