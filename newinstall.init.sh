#!/bin/bash

#-------------------------------------------------
if [ -z ${1+x} ]; then
	echo "new Hostname is needed"
	exit
fi

#-------------------------------------------------
addto_fstab() {
	if ! sudo grep -Fxq "$*" /etc/fstab; then
		echo "$*" | sudo tee -a /etc/fstab
	fi
}

addto_crontab() {
	cronfile=/var/spool/cron/crontabs/$(whoami)
	
	if ! sudo grep -Fxq "$*" $cronfile; then
		echo "$*" | sudo tee -a $cronfile
	fi
	
	sudo chown $(whoami):crontab $cronfile
}

addto_anacrontab() {
	cronfile=/etc/anacrontab
	
	sudo touch $cronfile
	
	if ! sudo grep -Fxq "$*" $cronfile; then
		echo "$*" | sudo tee -a $cronfile
	fi
}

#-------------------------------------------------
BASEDIR=$(dirname $0)

#-------------------------------------------------
sudo apt update
sudo apt-get install -y git ntpdate samba tmux at

#-------------------------------------------------
sh ${BASEDIR}/gitconf.sh

sh ${BASEDIR}/gitsync.sh

sh ${BASEDIR}/install_sshkey.sh

sh ${BASEDIR}/timezone.fix.sh

#-------------------------------------------------
#edit crontab 
#sudo crontab -e
# 0 6 * * 0 /usr/bin/batch < /home/vagrant/script/update.sh
addto_crontab "0 6 * * 0 /usr/bin/batch < /home/$(whoami)/script/update.sh"
# 0 6 * * 1 /usr/bin/batch < /home/vagrant/script/cleanup.sh
addto_crontab "0 6 * * 1 /usr/bin/batch < /home/$(whoami)/script/cleanup.sh"
##0 6 * * * /usr/bin/batch < /home/vagrant/script/backup.sh
addto_crontab "#0 6 * * * /usr/bin/batch < /home/$(whoami)/script/backup.sh"
#	or anacron
#sudo apt-get install anacron
#sudo vi /etc/anacrontab
# 7       20      update          /usr/bin/batch < /home/sita/script/update.sh
addto_anacrontab "7 20 update /usr/bin/batch < /home/$(whoami)/script/update.sh"
# 7       25      cleanup         /usr/bin/batch < /home/sita/script/cleanup.sh
addto_anacrontab "7 25 cleanup /usr/bin/batch < /home/$(whoami)/script/cleanup.sh"
# #7      30      backup          /usr/bin/batch < /home/sita/script/backup.sh
addto_anacrontab "#7 30 backup /usr/bin/batch < /home/$(whoami)/script/backup.sh"

#-------------------------------------------------
#change hostname

# sudo vi /etc/hostname
echo $1 | sudo tee /etc/hostname

# sudo vi /etc/hosts
sudo sed -i "s/$(hostname)/$1/g" /etc/hosts

# echo sudo hostname xxxx
sudo hostname $1

#-------------------------------------------------
#vi /etc/nsswitch.conf
#hosts:          files wins dns
sed -i 's/hosts:          files dns/hosts:          files dns wins mdns4_minimal/g' /etc/nsswitch.conf

# echo sudo /etc/init.d/samba restart & exit
sudo /etc/init.d/samba restart

#-------------------------------------------------
# ramdisk 
# sudo vi /etc/fstab
# tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
# tmpfs /var/spool tmpfs defaults,noatime,mode=1777 0 0
# tmpfs /var/tmp tmpfs defaults,noatime,mode=1777 0 0
addto_fstab tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
addto_fstab tmpfs /var/spool tmpfs defaults,noatime,mode=1777 0 0
addto_fstab tmpfs /var/tmp tmpfs defaults,noatime,mode=1777 0 0

echo ===============
echo not for server
echo ===============
echo tmpfs /var/log tmpfs defaults,noatime,mode=0755 0 0

#-------------------------------------------------
#ssh host

echo ===============
echo tmux
echo ===============

echo ===============
echo sh ${BASEDIR}/newinstall.sh
echo ===============

echo ===============
echo sh ${BASEDIR}/update.sh
echo ===============

#-------------------------------------------------
echo ===============
echo Host IP for ssh
echo ===============
ip addr show | grep 192

