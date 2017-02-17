apt-get install -y sudo

echo $(whoami) ALL=(ALL) ALL > /etc/sudoers.d/$(whoami)
