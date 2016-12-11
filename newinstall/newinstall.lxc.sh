#!/bin/bash

create_sudo_cfg() {
	file=/etc/sudoers.d/$(whoami)

	if [ ! -e $file ]; then
		su -s /bin/bash -c "echo \"$(whoami)    ALL=(ALL) ALL\" > $file"
	fi
}

clone_script() {
	if [ ! -d ~/script ]; then
		pushd ~/
		git clone https://github.com/chsliu/script.git
		popd
	fi
}

newuser() {
	if [ ! -z ${1+x} ]; then 
		sudo adduser $1
		sudo addgroup $1
		sudo adduser $1 $1 
		sudo adduser $1 users

		sudo smbpasswd -a $1
		sudo pdbedit -w -L
		sudo /etc/init.d/samba restart

		smbclient -L //localhost -U $1
	fi
}

createdir() {
	if [ -d "$1" ]; then return; fi
	
	mkdir $1
}

addto_sshkey() {
	sshkeys=~/.ssh/authorized_keys

	if ! grep -Fxq "$*" $sshkeys; then
		echo $* | tee -a $sshkeys
	fi
}

#-------------------------------------------------
su -s /bin/bash -c "apt install -y sudo ca-certificates git samba libnss-winbind"

#-------------------------------------------------
create_sudo_cfg

#-------------------------------------------------
sudo dpkg-reconfigure tzdata

#-------------------------------------------------
clone_script

#-------------------------------------------------
sudo sed -i 's/hosts:          files dns/hosts:          files wins dns mdns4_minimal/g' /etc/nsswitch.conf

# . ~/script/pve/newuser $(whoami)
newuser $(whoami)

# sudo /etc/init.d/samba restart

#-------------------------------------------------
# . ~/script/newinstall/install_sshkey.sh

createdir ~/.ssh

addto_sshkey ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlnbdmUXHVzxDEmqKTP4Hci8Kq4BU9LA8piUHSbHA+Y+lLt/I0yg+uglpF1bOIp67Hqlf0MfITB0YkQ1uzJ4JIGDxOq3V2L+9M1PeOJ3+ProUaN3itBwNQoAQUPWTzRxIceHfXazYgwsVIG6VyJvt/+Tt6OmrPVjRwruiMWsjBregHmuCH37ca52Hb0uDC/5fSzGrBj9RnSMMkI9zaywdy2BQg1sQ2d8lTl0zgq1TR3wuTHIrYWmSCEs9k/0AQfCPdmS57yzW2CnNpuY3RFCyG60AM9P6mIx7WORghFI7zNu8QkqCfvpqzIbjwnTJjocs4+LVVcoFoxnJsVY0ZJvX0Q==
