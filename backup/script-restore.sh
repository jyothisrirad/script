#!/bin/sh

if [ ! -d ~/share ]; then
	mkdir ~/share
fi

if [ ! -d ~/script ]; then
	mkdir ~/script
fi

if mount | grep ~/share > /dev/null; then
    sudo umount ~/share
fi

sudo mount //192.168.1.247/software ~/share -o rw,user=sita,pass=1 

sudo cp ~/share/UNIX/Lubuntu/script/*.sh ~/script/

sudo umount ~/share

sudo chown `whoami`:`whoami` ~/script/*.sh

chmod +x ~/script/*.sh
