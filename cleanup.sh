#!/bin/sh

#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )
#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-headers-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )


sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean

rm -rf /home/sita/.local/share/Trash/*
rm /home/$USER/xbmc*.log
rm /home/$USER/kodi*.log
