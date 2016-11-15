#!/bin/bash

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

createdir ~/.ssh

# echo ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlnbdmUXHVzxDEmqKTP4Hci8Kq4BU9LA8piUHSbHA+Y+lLt/I0yg+uglpF1bOIp67Hqlf0MfITB0YkQ1uzJ4JIGDxOq3V2L+9M1PeOJ3+ProUaN3itBwNQoAQUPWTzRxIceHfXazYgwsVIG6VyJvt/+Tt6OmrPVjRwruiMWsjBregHmuCH37ca52Hb0uDC/5fSzGrBj9RnSMMkI9zaywdy2BQg1sQ2d8lTl0zgq1TR3wuTHIrYWmSCEs9k/0AQfCPdmS57yzW2CnNpuY3RFCyG60AM9P6mIx7WORghFI7zNu8QkqCfvpqzIbjwnTJjocs4+LVVcoFoxnJsVY0ZJvX0Q== >> ~/.ssh/authorized_keys

addto_sshkey ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlnbdmUXHVzxDEmqKTP4Hci8Kq4BU9LA8piUHSbHA+Y+lLt/I0yg+uglpF1bOIp67Hqlf0MfITB0YkQ1uzJ4JIGDxOq3V2L+9M1PeOJ3+ProUaN3itBwNQoAQUPWTzRxIceHfXazYgwsVIG6VyJvt/+Tt6OmrPVjRwruiMWsjBregHmuCH37ca52Hb0uDC/5fSzGrBj9RnSMMkI9zaywdy2BQg1sQ2d8lTl0zgq1TR3wuTHIrYWmSCEs9k/0AQfCPdmS57yzW2CnNpuY3RFCyG60AM9P6mIx7WORghFI7zNu8QkqCfvpqzIbjwnTJjocs4+LVVcoFoxnJsVY0ZJvX0Q==
