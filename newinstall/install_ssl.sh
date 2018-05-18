#!/bin/bash

### 
addto_root_crontab() {
	! sudo crontab -l | grep -Fxq "$*" && su - root -c "(crontab -l; echo \"$*\") | crontab -"
}

### 
sudo mkdir /opt
sudo mkdir /opt/bitnami
sudo mkdir /opt/bitnami/letsencrypt
cd /opt/bitnami/letsencrypt
sudo wget https://github.com/xenolf/lego/releases/download/v0.4.1/lego_linux_amd64.tar.xz
sudo tar xf lego_linux_amd64.tar.xz
sudo rm lego_linux_amd64.tar.xz
sudo mv lego_linux_amd64 lego
sudo rsync -az rsync://home.changen.com.tw/NetBackup/rsync/acme-v01.api.letsencrypt.org /opt/bitnami/letsencrypt/accounts/

if [ ! -z "$1" ]; then
    # Register New Domain certificate
    [ ! -f /opt/bitnami/letsencrypt/certificates/$1.crt ] && sudo /opt/bitnami/letsencrypt/lego --path "/opt/bitnami/letsencrypt" --email="chsliu@gmail.com" --domains="$1" run
    # Monthly Update Domain certificate
    [ -f /opt/bitnami/letsencrypt/certificates/$1.crt ] && addto_root_crontab "0 0 * * * /opt/bitnami/letsencrypt/lego --path '/opt/bitnami/letsencrypt' --email='chsliu@gmail.com' --domains=\"$1\" renew --days 30"
fi
