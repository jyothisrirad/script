#!/bin/bash

addto_fstab() {
	fsfile=/etc/fstab

	if ! sudo grep -Fxq "$*" $fsfile; then
		echo $* | sudo tee -a $fsfile
	fi
}

sudo mkdir /mnt/runtimes
sudo chown sita:sita /mnt/runtimes

sudo mkdir /mnt/backup
sudo chown sita:sita /mnt/backup

sudo apt install -y zip dnsutils uni2ascii bc

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt update
sudo apt install -y oracle-java8-installer gcsfuse

mkdir /home/sita/.gcloud && rsync -az rsync://home.changen.com.tw/NetBackup/rsync/gcloud/chsliu@gmail.com.json /home/sita/.gcloud/
# gcloud iam service-accounts keys create /home/sita/script/minecraft/gcloud/key.json --iam-account=594227564613-compute@developer.gserviceaccount.com
addto_fstab creeper-tw-backup /mnt/backup gcsfuse rw,noauto,user,key_file=/home/sita/.gcloud/chsliu@gmail.com.json

# cd /tmp
# google-fluentd google-fluentd-catch-all-config
# curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
# sudo bash install-logging-agent.sh
# stackdriver-agent
# curl -sSO https://repo.stackdriver.com/stack-install.sh
# sudo bash stack-install.sh --write-gcm
