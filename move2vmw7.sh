#!/bin/sh

if [ ! -d ~/share ]; then
	mkdir ~/share
fi

if mount | grep ~/share > /dev/null; then
    sudo umount ~/share
fi

sudo mount //192.168.1.247/software/unix/lubuntu ~/share -o rw,user=sita,pass=1

sudo mv "$1" ~/share/

sudo umount ~/share
