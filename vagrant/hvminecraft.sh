sudo mount -t cifs -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3`,sec=ntlm,username=sita,password=1 //192.168.1.246/9f6bf82f682f3062d4a91da677673954 /vagrant

