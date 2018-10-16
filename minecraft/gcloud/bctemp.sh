#!/bin/bash

#=================================
. /home/sita/script/include/console.color

#=================================
gandi=/home/sita/script/mis/dns.gandi.creeper.tw.sh
RECORD=r53

#=================================
# setmachine=/home/sita/script/minecraft/gcloud/setmachine.sh
bc1=/home/sita/script/minecraft/gcloud/bungeecord.sh
bc3=/home/sita/script/minecraft/gcloud/igroup3.sh

#=================================
addto_crontab() {
	(crontab -l; echo "$*") | crontab -
}

delfrom_crontab() {
	line=$*
	line=$(echo "$line" | sed 's/\//\\\//g')
	crontab -l | sed "/$line/d" | crontab -
}

#=================================
lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

#=================================
my_ip_address() {
    curl -s4 http://me.gandi.net
}

#=================================
# start_bc() {
    # 1.7 GB
    # $setmachine sita@changen.com.tw bungeecord-tw2 g1-small
    # gcloud --account "sita@changen.com.tw" --project "creeper-199909" compute instances start bungeecord-tw2
    
    # echo $bc3 start $1
    # $bc3 start $1
# }

#=================================
# stop_bc() {
    # echo $bc3 stop $1
    # $bc3 stop $1
    
    # gcloud --account "sita@changen.com.tw" --project "creeper-199909" compute instances stop bungeecord-tw2
    # 0.6 GB
    # $setmachine sita@changen.com.tw bungeecord-tw2 f1-micro
# }

#=================================
update_dns() {
    echo DNS Groups: $(basename $0)
	
	# echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	# bcip+=$(lookup_dns_ip gem.creeper.tw)
	# bcip+=" "
	
	echo -e Collecting ip: ${GREEN}"bc.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip bc.creeper.tw)
	bcip+=" "

	echo -e Collecting ip: ${GREEN}"chsliu@gmail.com"${NC}
	bcip+=$(gcloud --account "chsliu@gmail.com" --project "creeper-196707" compute instances list | grep RUNNING | grep -E "(-[0-9a-z]{4})\b" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -v '10.1')
	bcip+=" "

	echo -e Collecting ip: ${GREEN}"sita@changen.com.tw"${NC}
	bcip+=$(gcloud --account "sita@changen.com.tw" --project "creeper-199909" compute instances list | grep RUNNING | grep -E "(-[0-9a-z]{4})\b" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -v '10.1')
	bcip+=" "

	echo -e Collecting ip: ${GREEN}"creeper.workshop@gmail.com"${NC}
	bcip+=$(gcloud --account "creeper.workshop@gmail.com" --project "creeperworkshop-web" compute instances list | grep RUNNING | grep -E "(-[0-9a-z]{4})\b" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -v '10.1')
	bcip+=" "

	bcip=$(echo $bcip|tr ' ' '\n'|sort -u)
	echo -e bcip: ${GREEN}$bcip${NC}

	$gandi set $RECORD $bcip
}

#=================================
dns_stop() {
    echo DNS Groups: $(basename $0)
	
	echo -e Collecting ip: ${GREEN}"bc.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip bc.creeper.tw)
	bcip+=" "
	
	echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip gem.creeper.tw)
	bcip+=" "

	$gandi set $RECORD $bcip
}

#=================================
dns_stop2() {
    echo DNS Groups: $(basename $0)
	
	echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip gem.creeper.tw)
	bcip+=" "

	$gandi set $RECORD $bcip
}

#=================================
case "$1" in
  install)
    delfrom_crontab "$(basename $0)"
	addto_crontab "#gcloud DNS update $(basename $0)"
    addto_crontab "* * * * * /bin/bash $(readlink -e $0)"
    exit
    ;;
  remove)
    delfrom_crontab "$(basename $0)"
    exit
    ;;
  start)
    $0 install
    # start_bc
    $bc1 start small
	$bc3 start $2 $2
    update_dns
    exit
    ;;
  prestop)
    $0 remove
    dns_stop
    ;;
  stop)
    $0 remove
	$bc3 stop
    dns_stop
    exit
    ;;
  stop2)
    # stop_bc
    $bc1 stop
	$0 stop
	dns_stop2
    ;;
  *)
    update_dns
esac
