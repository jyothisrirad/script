#!/bin/sh
#
# ./inst.as.sh start.mc.d startmc
#

[ $1 ] || echo "usage: $0 <script> <service_name>"
[ $1 ] || exit
[ $2 ] || exit

YOUR_SERVICE_NAME=$2
SCRIPT="/etc/init.d/$YOUR_SERVICE_NAME"

# replace "$YOUR_SERVICE_NAME" with your service's name
[ -f "$SCRIPT" ] && sudo rm "$SCRIPT"
# sudo cp "$1" "/etc/init.d/$YOUR_SERVICE_NAME"
sudo ln -s "$(readlink -e $1)" "/etc/init.d/$YOUR_SERVICE_NAME"
sudo chmod +x /etc/init.d/$YOUR_SERVICE_NAME
sudo chown root /etc/init.d/$YOUR_SERVICE_NAME
sudo chgrp root /etc/init.d/$YOUR_SERVICE_NAME

sudo update-rc.d $YOUR_SERVICE_NAME defaults
