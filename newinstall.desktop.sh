#################
###DESKTOP###
#################

###teamviewer
#wget http://download.teamviewer.com/download/teamviewer_linux.deb
#sudo dpkg -i teamviewer_linux.deb
#rm teamviewer_linux.deb
wget http://download.teamviewer.com/download/teamviewer_i386.deb
sudo dpkg -i teamviewer_i386.deb
rm teamviewer_i386.deb
sudo apt-get -f install -y

###rdp
sudo apt-get install -y xrdp

###chrome
sudo apt-add-repository -y "deb http://dl.google.com/linux/chrome/deb/ stable main"
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -


#####
sudo apt-get update
sudo apt-get install -y google-chrome-stable
