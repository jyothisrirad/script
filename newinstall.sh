#!/bin/bash

BASEDIR=$(dirname $0)

#script screen.log
#-------------------------------------------------------------------------------------------

##########
###misc###
##########
#hyper-v ubuntu vm
echo 0 | sudo sh -c ">/proc/sys/kernel/hung_task_timeout_secs"


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

sh ${BASEDIR}/newinstall.console.sh


read -p "Press Any Key to continue to install Desktop related Software..."

sh ${BASEDIR}/newinstall.desktop.sh


read -p "Press Any Key to continue to install HTPC related Software..."

sh ${BASEDIR}/newinstall.htpc.sh


read -p "Press Any Key to continue to install Workstation related Software..."

sh ${BASEDIR}/newinstall.workstation.sh


read -p "Press Any Key to continue to install Developer related Software..."

sh ${BASEDIR}/newinstall.developer.sh


#-------------------------------------------------------------------------------------------
exit
