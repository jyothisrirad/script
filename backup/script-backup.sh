#!/bin/sh

if [ ! -d ~/share ]; then
	mkdir ~/share
fi

if mount | grep ~/share > /dev/null; then
    sudo umount ~/share
fi

sudo mount //192.168.1.247/software ~/share -o rw,user=sita,pass=1 

sudo cp ~/script/*.sh ~/share/UNIX/Lubuntu/script

sudo umount ~/share
