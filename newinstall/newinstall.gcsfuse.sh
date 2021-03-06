#!/bin/bash

# [ ! -d /mnt/backup ] && sudo mkdir /mnt/backup
# sudo chown sita:sita /mnt/backup

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt update
sudo apt install -y gcsfuse

[ ! -d /home/sita/.gcloud ] && mkdir /home/sita/.gcloud || rsync -az rsync://home.changen.com.tw/NetBackup/rsync/gcloud/*.json /home/sita/.gcloud/
