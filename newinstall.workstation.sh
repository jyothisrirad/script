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

echo '#' >>~/.bashrc
echo '#' >>~/.bashrc
echo '#' >>~/.bashrc
echo 'export PATH="$PATH:~/script"' >>~/.bashrc
echo '' >>~/.bashrc
echo '#' >>~/.bashrc
echo 'if [ -f /usr/bin/screenfetch ]; then screenfetch; fi' >>~/.bashrc


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
sudo apt-get install -y google-chrome-stable
#sudo apt-get update
sudo apt-get install -y variety
sudo apt-get install -y grub-customizer
sudo apt-get install -y unity-control-center

