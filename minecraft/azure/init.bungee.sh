#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

s65
mcserver restore

sudo rm /etc/logrotate.d/bungeecord
sudo ln -s /mnt/runtimes/65-bungeeCord-azure/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord-azure/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord

~/script/init.d/inst.as.sh ~/script/init.d/bungee.d bungeestart
