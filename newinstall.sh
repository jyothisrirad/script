#!/bin/bash

BASEDIR=$(dirname $0)

#script screen.log
#-------------------------------------------------------------------------------------------

##########
###misc###
##########
#hyper-v ubuntu vm
echo 0 | sudo sh -c ">/proc/sys/kernel/hung_task_timeout_secs"


echo "Install Fast Mirror"
sh ${BASEDIR}/newinstall.fastmirror.sh


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
