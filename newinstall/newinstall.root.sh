if [ ! "root" = $(whoami) ]; then
	echo "only work while been root"
	exit
fi

apt-get install -y sudo

echo "$(whoami) ALL=(ALL) ALL" > /etc/sudoers.d/$(whoami)
