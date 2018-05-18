#!/bin/bash

###
addto_root_crontab() {
	! sudo crontab -l | grep -Fxq "$*" && su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

###
case "$1" in
  install)
	addto_root_crontab "#iptable load"
	addto_root_crontab "@reboot /bin/bash $(readlink -e $0) load"
    exit
    ;;
    
  save)
    echo Saving iptables
    sudo iptables-save | sudo tee /etc/iptables.conf
    exit
    ;;
    
  load)
    [ -f /etc/iptables.conf ] && echo Loading iptables && sudo iptables-restore < /etc/iptables.conf
    exit
    ;;
    
  *)
	echo "Usage: $0 {install|save|load}"
	exit 1
	;;
    
esac
