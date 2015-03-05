#!/bin/sh

sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )
sudo apt-get -y purge $( dpkg --list | grep -P -o "linux-headers-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") )

sh ~/script/cleanup.sh
