#!/bin/sh

if [ ! -d ~/share ]; then
	mkdir ~/share
fi

if mount | grep ~/share > /dev/null; then
    sudo umount ~/share
fi

sudo mount //192.168.1.247/software/UNIX/Lubuntu ~/share -o rw,user=sita,pass=1 

sudo cp -R ~/share/xbmc/userdata/favourites.xml ~/.xbmc/userdata/

sudo umount ~/share

sudo chown -R `whoami`:`whoami` ~/.xbmc/userdata/favourites.xml

chmod -R -x ~/.xbmc/userdata/favourites.xml
