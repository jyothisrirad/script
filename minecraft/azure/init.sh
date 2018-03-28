sudo mkdir /mnt/runtimes
sudo chown sita:sita /mnt/runtimes

sudo mkdir /mnt/backup
sudo chown sita:sita /mnt/backup

sudo apt install -y zip dnsutils uni2ascii

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
sudo apt update
sudo apt install -y oracle-java8-installer
