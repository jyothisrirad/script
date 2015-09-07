#!/bin/sh

BASEDIR=$(dirname $0)

#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )
#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-headers-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )


sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean

#rm -rf /home/$USER/.local/share/Trash/*
#rm /home/$USER/xbmc*.log
#rm /home/$USER/kodi*.log
rm -rf ${BASEDIR}/../.local/share/Trash/*
rm ${BASEDIR}/../xbmc*.log
rm ${BASEDIR}/../kodi*.log
