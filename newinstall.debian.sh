BASEDIR=$(dirname $0)

sudo apt-get install -y git ntpdate samba tmux

sh ${BASEDIR}/gitconf.sh

sh ${BASEDIR}/gitsync.sh

sh ${BASEDIR}/install_sshkey.sh

sh ${BASEDIR}/timezone.fix.sh

#-------------------------------------------------
#change hostname
sudo vi /etc/hostname
sudo vi /etc/hosts
echo sudo hostname xxxx

echo sudo /etc/init.d/samba restart & exit
