#!/bin/bash

clone_script() {
if [ ! -d ~/script ]; then
	pushd ~/
	git clone https://github.com/chsliu/script.git
	popd
fi
}

#-------------------------------------------------
su -s /bin/bash -c "apt install -y sudo ca-certificates git samba libnss-winbind"

#-------------------------------------------------
sudo cp ~/script/pve/etc/sudoers.d/sita /etc/sudoers.d/$(whoami)

#-------------------------------------------------
clone_script

#-------------------------------------------------
sudo sed -i 's/hosts:          files dns/hosts:          files wins dns mdns4_minimal/g' /etc/nsswitch.conf

. ~/script/pve/newuser $(whoami)

# sudo /etc/init.d/samba restart

#-------------------------------------------------
. ~/script/newinstall/install_sshkey.sh
