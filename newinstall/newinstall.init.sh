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
	
	sudo touch $cronfile

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
sudo apt-get install -y git ntpdate samba tmux at libnss-winbind rsync cron screen nfs-common htop bc

#-------------------------------------------------
sh ${BASEDIR}/../gitconf.sh

sh ${BASEDIR}/../gitsync.sh

sh ${BASEDIR}/install_sshkey.sh

sh ${BASEDIR}/timezone.fix.sh

#-------------------------------------------------
#crontab jobs
addto_crontab "###################"
addto_crontab "#server maintenance"
addto_crontab "###################"
addto_crontab "0 6 * * 0 /usr/bin/batch < /home/$(whoami)/script/update.sh"
addto_crontab "0 6 * * 1 /usr/bin/batch < /home/$(whoami)/script/cleanup.sh"
addto_crontab "#0 6 * * * /usr/bin/batch < /home/$(whoami)/script/backup.sh"
addto_crontab "###################"

#anacron jobs
addto_anacrontab "###################"
addto_anacrontab "#server maintenance"
addto_anacrontab "###################"
addto_anacrontab "7 20 update /usr/bin/batch < /home/$(whoami)/script/update.sh"
addto_anacrontab "7 25 cleanup /usr/bin/batch < /home/$(whoami)/script/cleanup.sh"
addto_anacrontab "#7 30 backup /usr/bin/batch < /home/$(whoami)/script/backup.sh"
addto_anacrontab "###################"

#-------------------------------------------------
#change hostname

# sudo vi /etc/hostname
echo $1 | sudo tee /etc/hostname

# sudo vi /etc/hosts
sudo sed -i "s/$(hostname)/$1/g" /etc/hosts

# echo sudo hostname xxxx
sudo hostname $1

#-------------------------------------------------
# avoid CUPS messages
# cat /var/log/samba/log.smbd
sudo sed -i 's/\[global\]/\[global\]\nprinting = bsd\nprintcap name = \/dev\/null\n/' /etc/samba/smb.conf

#-------------------------------------------------
#vi /etc/nsswitch.conf
#hosts:          files wins dns
sudo sed -i 's/hosts:          files dns/hosts:          files wins dns mdns4_minimal/g' /etc/nsswitch.conf

# echo sudo /etc/init.d/samba restart & exit
sudo /etc/init.d/samba restart

#-------------------------------------------------
# ramdisk 
# sudo vi /etc/fstab
# tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
# tmpfs /var/spool tmpfs defaults,noatime,mode=1777 0 0
# tmpfs /var/tmp tmpfs defaults,noatime,mode=1777 0 0
addto_fstab tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
#addto_fstab tmpfs /var/spool tmpfs defaults,noatime,mode=1777 0 0
addto_fstab tmpfs /var/tmp tmpfs defaults,noatime,mode=1777 0 0

echo ===========================================
echo For workstation, add this line to /etc/fstab
echo ===========================================
addto_fstab \#For workstation, uncomment the line on /var/log
addto_fstab \#tmpfs /var/log tmpfs defaults,noatime,mode=0755 0 0

#-------------------------------------------------
# generate the missing locale
echo choose "en_US.UTF-8"
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales

#-------------------------------------------------
#ssh host

echo =====================================
echo Run tmux before running scripts below
echo =====================================
echo tmux
echo ---------------------------
echo sh ${BASEDIR}/newinstall.sh
echo ---------------------------
echo sh ${BASEDIR}/update.sh

#-------------------------------------------------
#alias
cp ${BASEDIR}/.bash_aliases ~/

#-------------------------------------------------
echo ===============
echo Host IP for ssh
echo ===============
ip addr show | grep 192

#-------------------------------------------------
echo =====================
echo set password for root
echo =====================
sudo passwd root

#-------------------------------------------------
sudo sed -i 's/ftp.debian.org/ftp.tw.debian.org/g' /etc/apt/sources.list

#-------------------------------------------------
echo ==================
echo install BBR, 1,3,8
echo ==================
pushd /tmp
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && sudo ./tcp.sh
