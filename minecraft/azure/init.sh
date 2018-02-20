sudo mkdir /mnt/runtimes
sudo mkdir /mnt/backup

sudo chown sita:sita /mnt/runtimes
sudo chown sita:sita /mnt/backup

sudo apt install -y zip

sudo apt install -y software-properties-common
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt install -y oracle-java8-installer
