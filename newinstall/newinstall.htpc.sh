##########
###HTPC###
##########
###xbmc
sudo apt-get install -y python-software-properties pkg-config
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:team-xbmc/ppa

###spotify
#sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free" 
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

###teamviewer
wget http://download.teamviewer.com/download/teamviewer_linux.deb
sudo dpkg -i teamviewer_linux.deb
rm teamviewer_linux.deb
sudo apt-get -f install -y

#####
sudo apt-get update
sudo apt-get install -y avahi-daemon
sudo apt-get install -y kodi
#sudo apt-get update -qq
sudo apt-get install -y spotify-client

###ubuntu-drivers
sudo ubuntu-drivers autoinstall
