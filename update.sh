#!/bin/sh

echo "Script executed from: ${PWD}"

BASEDIR=$(dirname $0)
echo "Script location: ${BASEDIR}"

if [ -x ${BASEDIR}/config.sh ];
then
  echo Run config
  . ${BASEDIR}/config.sh
fi

#sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )

sudo getfastmirror update -t
sudo rm /etc/apt/sources.list.d/*.*.*
python -mplatform | grep debian && sudo sed -i 's/ubuntu/debian/' /etc/apt/sources.list

sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y upgrade
#sudo apt-get -y autoremove

sudo youtube-dl -U
sudo pip install -U youtube-dl

#cd /home/$USER/script
#sh /home/$USER/script/gitsync.sh
cd ${BASEDIR}
sh gitconf.sh
sh gitsync.sh

#sudo shutdown -r now
