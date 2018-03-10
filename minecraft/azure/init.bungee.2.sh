#!/bin/bash

### 
/mnt/runtimes/65-bungeeCord-azure/update.sh
/mnt/runtimes/65-bungeeCord-azure/update.sh
/mnt/runtimes/65-bungeeCord-azure/update.sh

sudo rm /etc/logrotate.d/bungeecord
sudo ln -s /mnt/runtimes/65-bungeeCord-azure/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord-azure/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord

echo !!!!!!!!!!!!!!
echo vi /mnt/runtimes/65-bungeeCord-azure/plugins/RedisBungee/config.yml
echo !!!!!!!!!!!!!!
