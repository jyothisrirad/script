BASEDIR=$(dirname $0)

#-------------------------------------------------
#get ip
# ip addr show

#ssh ip

#-------------------------------------------------
sudo apt-get install -y git ntpdate samba tmux

sh ${BASEDIR}/gitconf.sh

sh ${BASEDIR}/gitsync.sh

sh ${BASEDIR}/install_sshkey.sh

sh ${BASEDIR}/timezone.fix.sh

#edit crontab
# 0 6 * * 0 /usr/bin/batch < /home/vagrant/script/update.sh
# 0 6 * * 1 /usr/bin/batch < /home/vagrant/script/cleanup.sh
##0 6 * * * /usr/bin/batch < /home/vagrant/script/backup.sh

#-------------------------------------------------
#change hostname

sudo vi /etc/hostname

sudo vi /etc/hosts

echo sudo hostname xxxx

echo sudo /etc/init.d/samba restart & exit

#-------------------------------------------------
#ssh host

echo tmux

echo sh ${BASEDIR}/newinstall.sh

echo sh ${BASEDIR}/update.sh

