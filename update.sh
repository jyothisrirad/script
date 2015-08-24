#!/bin/sh

#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )

sudo getfastmirror update -t
sudo rm /etc/apt/sources.list.d/*.*.*
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
#sudo apt-get -y autoremove

cd /home/sita/script
sh /home/sita/script/gitsync.sh

#sudo shutdown -r now
