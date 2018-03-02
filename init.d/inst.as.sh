[ $1 ] || echo "usage: $0 <script> <service_name>"
[ $1 ] || exit
[ $2 ] || exit

YOUR_SERVICE_NAME=$2

# replace "$YOUR_SERVICE_NAME" with your service's name
sudo cp "$1" "/etc/init.d/$YOUR_SERVICE_NAME"
sudo chmod +x /etc/init.d/$YOUR_SERVICE_NAME
sudo chown root /etc/init.d/$YOUR_SERVICE_NAME
sudo chgrp root /etc/init.d/$YOUR_SERVICE_NAME

sudo update-rc.d $YOUR_SERVICE_NAME defaults
