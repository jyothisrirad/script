65
mcrestore

sudo ln -s /mnt/runtimes/65-bungeeCord/logrotate /etc/logrotate.d/bungeecord
sudo chown root /mnt/runtimes/65-bungeeCord/logrotate
sudo logrotate -d /etc/logrotate.d/bungeecord

~/script/init.d/inst.as.sh ~/script/init.d/bungee.d bungeestart
