#!/bin/sh

if [ ! -d ~/share ]; then
	mkdir ~/share
fi

if [ ! -d ~/.xbmc/userdata ]; then
	mkdir -p ~/.xbmc/userdata/keymaps/
fi

if mount | grep ~/share > /dev/null; then
    sudo umount ~/share
fi

sudo mount //192.168.1.247/software/UNIX/Lubuntu ~/share -o rw,user=sita,pass=1 

sudo cp -R ~/share/xbmc/userdata/*.xml ~/.xbmc/userdata/
sudo cp -R ~/share/xbmc/userdata/keymaps/*.xml ~/.xbmc/userdata/keymaps/
sudo cp -R ~/share/xbmc/userdata/playlists/video/*.m3u ~/.xbmc/userdata/playlists/video/

sudo umount ~/share

sudo chown -R `whoami`:`whoami` ~/.xbmc/userdata/*.xml
sudo chown -R `whoami`:`whoami` ~/.xbmc/userdata/keymaps/*.xml
sudo chown -R `whoami`:`whoami` ~/.xbmc/userdata/playlists/video/*.m3u

chmod -R -x ~/.xbmc/userdata/*.xml
chmod -R -x ~/.xbmc/userdata/keymaps/*.xml
chmod -R -x ~/.xbmc/userdata/playlists/video/*.m3u

