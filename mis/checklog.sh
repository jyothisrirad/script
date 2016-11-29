uname -mrs
lsb_release -a
dmesg | egrep -i 'err|warn|critical'
sudo tail -f /var/log/myapp
