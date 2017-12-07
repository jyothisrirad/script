[ $1 ] || echo "usage: $0 <script> <service_name>"
[ $1 ] || exit
[ $2 ] || exit

YOUR_SERVICE_NAME=$2

# replace "$YOUR_SERVICE_NAME" with your service's name
cp "$1" "/etc/init.d/$YOUR_SERVICE_NAME"
chmod +x /etc/init.d/$YOUR_SERVICE_NAME
chown root /etc/init.d/$YOUR_SERVICE_NAME
chgrp root /etc/init.d/$YOUR_SERVICE_NAME

update-rc.d $YOUR_SERVICE_NAME defaults
