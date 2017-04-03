if [ ! "root" = $(whoami) ]; then
	echo "only work while been root"
	exit
fi

apt-get install -y sudo

newuser=sita

adduser $newuser

echo "$newuser ALL=(ALL) ALL" > /etc/sudoers.d/$newuser
