#!/bin/bash

if [ ! "root" = $(whoami) ]; then
	echo "only work while been root"
	exit
fi

### 
addto_root_crontab() {
	! sudo crontab -l | grep -Fxq "$*" && su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
[ ! -d /opt ] && sudo mkdir /opt
[ ! -d /opt/bitnami ] && sudo mkdir /opt/bitnami
[ ! -d /opt/bitnami/letsencrypt ] && sudo mkdir /opt/bitnami/letsencrypt

cd /opt/bitnami/letsencrypt
[ ! -f lego ] && sudo wget https://github.com/xenolf/lego/releases/download/v0.4.1/lego_linux_amd64.tar.xz
[ ! -f lego ] && sudo tar xf lego_linux_amd64.tar.xz
[ ! -f lego ] && sudo rm lego_linux_amd64.tar.xz
[ ! -f lego ] && sudo mv lego_linux_amd64 lego

sudo rsync -az rsync://home.changen.com.tw/NetBackup/rsync/acme-v01.api.letsencrypt.org /opt/bitnami/letsencrypt/accounts/

if [ ! -z "$1" ]; then
    # Register New Domain certificate
    [ ! -f /opt/bitnami/letsencrypt/certificates/$1.crt ] && sudo /opt/bitnami/letsencrypt/lego --path "/opt/bitnami/letsencrypt" --email="chsliu@gmail.com" --domains="$1" run
    # Monthly Update Domain certificate
    [ -f /opt/bitnami/letsencrypt/certificates/$1.crt ] && addto_root_crontab "#update SSL certificate"
    [ -f /opt/bitnami/letsencrypt/certificates/$1.crt ] && addto_root_crontab "0 0 * * * /opt/bitnami/letsencrypt/lego --path '/opt/bitnami/letsencrypt' --email='chsliu@gmail.com' --domains=\"$1\" renew --days 30"
fi
