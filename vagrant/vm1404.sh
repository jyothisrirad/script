sudo mount -t cifs -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3`,sec=ntlm,username=sita,password=1 //192.168.1.246/03acacf38210ab84c9928554b4347b02 /vagrant

#sudo mount -t cifs -o uid=`id -u vagrant`,gid=`id -g vagrant`,sec=ntlm,username=sita,password=1 //192.168.1.246/03acacf38210ab84c9928554b4347b02 /vagrant
