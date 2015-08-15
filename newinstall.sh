#!/bin/bash

script screen.log
#-------------------------------------------------------------------------------------------

#############
###CONSOLE###
#############
###getfastmirror
cd /tmp
wget https://github.com/hychen/getfastmirror/archive/master.zip
unzip master.zip
sudo apt-get -y install python-setuptools
cd getfastmirror-master/
sudo ./setup.py install
cd ..
rm master.zip
sudo rm -rf getfastmirror-master
sudo getfastmirror update -t
sudo rm /etc/apt/sources.list.d/*.*.*

#####
sudo apt-get update

###kernal
sudo apt-get -y install linux-headers-generic linux-image-generic

###ssh
sudo apt-get -y install openssh-server

###vim
sudo apt-get -y install vim

###smartmontools
sudo apt-get -y install smartmontools

read -p "Press Any Key to continue to install HTPC related Software..."
##########
###HTPC###
##########
###xbmc
sudo apt-get -y install python-software-properties pkg-config
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:team-xbmc/ppa

###spotify
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free" 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

###teamviewer
wget http://download.teamviewer.com/download/teamviewer_linux.deb
sudo dpkg -i teamviewer_linux.deb
rm teamviewer_linux.deb
sudo apt-get -f -y install

#####
sudo apt-get update
sudo apt-get -y install avahi-daemon
sudo apt-get -y install xbmc
#sudo apt-get update -qq
sudo apt-get -y install spotify-client

###ubuntu-drivers
sudo ubuntu-drivers autoinstall


read -p "Press Any Key to continue to install Workstation related Software..."
#################
###WORKSTATION###
#################

###plank
sudo add-apt-repository -y ppa:ricotz/docky

###ubuntu tweak
sudo add-apt-repository -y ppa:tualatrix/ppa

###terminator
#sudo add-apt-repository -y ppa:gnome-terminator

###conky manager
sudo apt-add-repository -y ppa:teejee2008/ppa

###variety
sudo add-apt-repository -y ppa:peterlevi/ppa

###grub-customizer
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer

###hime
sudo apt-get -y purge ibus
sudo apt-get -y install hime im-switch
im-switch

###consola
sudo apt-get -y install fonts-inconsolata

###dos2unix
sudo apt-get -y install dos2unix

###mc
sudo apt-get -y install mc

###tmux
sudo apt-get -y install tmux

###playonlinux
sudo apt-get -y install playonlinux

###conky
sudo apt-get -y install conky

###remmina
sudo apt-get -y install remmina

###dconf-editor
sudo apt-get -y install dconf-editor

###kupfer
sudo apt-get -y install kupfer
#sudo apt-get -y install synapse

###chrome
#sudo apt-get -y install libxss1 libappindicator1 libindicator7
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
#sudo dpkg -i google-chrome*.deb
#rm google-chrome*.deb

sudo apt-add-repository -y "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

###gnome-commander
#sudo apt-get update
sudo apt-get -y install gnome-commander libgnomevfs2-extra

###gimp
sudo apt-get -y install gimp

###inkscape
sudo apt-get -y install inkscape

###screenfetch
wget https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev
chmod +x screenfetch-dev
sudo mv screenfetch-dev /usr/bin/screenfetch


#####
sudo apt-get update
sudo apt-get -y install plank
#sudo apt-get update
sudo apt-get -y install ubuntu-tweak
#sudo apt-get update
sudo apt-get -y install terminator
#sudo apt-get update
sudo apt-get -y install conky-manager
#sudo apt-get update
sudo apt-get install google-chrome-stable
#sudo apt-get update
sudo apt-get -y install variety
sudo apt-get -y install grub-customizer


read -p "Press Any Key to continue to install Developer related Software..."
#################
###DEVELOPER###
#################

###Sublime Text
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

###Ruby
sudo apt-get -y install ruby

###PHP
sudo apt-get -y install php-pear

###Node.js
sudo apt-get -y install nodejs
sudo apt-get -y install npm

###android studio
sudo apt-add-repository -y ppa:paolorotolo/android-studio


#####
sudo apt-get update
sudo apt-get -y install sublime-text-installer
sudo apt-get -y install android-studio


#-------------------------------------------------------------------------------------------
exit
