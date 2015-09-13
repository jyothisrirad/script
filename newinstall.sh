#!/bin/bash

#script screen.log
#-------------------------------------------------------------------------------------------

###################
###getfastmirror###
###################

#####
sudo apt-get install -y wget unzip python-setuptools

###getfastmirror
if [ ! -f /etc/apt/sources.list.original ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.original
fi
cd /tmp
wget https://github.com/hychen/getfastmirror/archive/master.zip
unzip -o master.zip
cd getfastmirror-master/
sudo ./setup.py install
cd ..
rm master.zip
sudo rm -rf getfastmirror-master
sudo getfastmirror update -t
sudo rm /etc/apt/sources.list.d/*.*.*
python -mplatform | grep debian && sudo sed -i 's/ubuntu/debian/' /etc/apt/sources.list

#####
sudo apt-get update


read -p "Press Any Key to continue to install Console related Software..."
#############
###CONSOLE###
#############

###kernal
sudo apt-get install -y linux-headers-generic linux-image-generic

###ssh
sudo apt-get install -y openssh-server

###vim
sudo apt-get install -y vim

###smartmontools
sudo apt-get install -y smartmontools


read -p "Press Any Key to continue to install HTPC related Software..."
##########
###HTPC###
##########
###xbmc
sudo apt-get install -y python-software-properties pkg-config
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:team-xbmc/ppa

###spotify
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free" 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

###teamviewer
wget http://download.teamviewer.com/download/teamviewer_linux.deb
sudo dpkg -i teamviewer_linux.deb
rm teamviewer_linux.deb
sudo apt-get -f install -y

#####
sudo apt-get update
sudo apt-get install -y avahi-daemon
sudo apt-get install -y xbmc
#sudo apt-get update -qq
sudo apt-get install -y spotify-client

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
sudo apt-get install -y hime im-switch
im-switch

###consola
sudo apt-get install -y fonts-inconsolata

###dos2unix
sudo apt-get install -y dos2unix

###mc
sudo apt-get install -y mc

###tmux
sudo apt-get install -y tmux

###playonlinux
sudo apt-get install -y playonlinux

###conky
sudo apt-get install -y conky

###remmina
sudo apt-get install -y remmina

###dconf-editor
sudo apt-get install -y dconf-editor

###kupfer
sudo apt-get install -y kupfer
#sudo apt-get install -y synapse

###chrome
#sudo apt-get install -y libxss1 libappindicator1 libindicator7
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
#sudo dpkg -i google-chrome*.deb
#rm google-chrome*.deb

sudo apt-add-repository -y "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

###gnome-commander
#sudo apt-get update
sudo apt-get install -y gnome-commander libgnomevfs2-extra

###gimp
sudo apt-get install -y gimp

###inkscape
sudo apt-get install -y inkscape

###screenfetch
wget https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev
chmod +x screenfetch-dev
sudo mv screenfetch-dev /usr/bin/screenfetch


#####
sudo apt-get update
sudo apt-get install -y plank
#sudo apt-get update
sudo apt-get install -y ubuntu-tweak
#sudo apt-get update
sudo apt-get install -y terminator
#sudo apt-get update
sudo apt-get install -y conky-manager
#sudo apt-get update
sudo apt-get install google-chrome-stable
#sudo apt-get update
sudo apt-get install -y variety
sudo apt-get install -y grub-customizer


read -p "Press Any Key to continue to install Developer related Software..."
#################
###DEVELOPER###
#################

###Sublime Text
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

###Ruby
sudo apt-get install -y ruby

###PHP
sudo apt-get install -y php-pear

###Node.js
sudo apt-get install -y nodejs
sudo apt-get install -y npm

###android studio
sudo apt-add-repository -y ppa:paolorotolo/android-studio


#####
sudo apt-get update
sudo apt-get install -y sublime-text-installer
sudo apt-get install -y android-studio


#-------------------------------------------------------------------------------------------
exit
