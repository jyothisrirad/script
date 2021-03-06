#!/bin/bash

#=================================
. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

#=================================
gandi=/home/sita/script/mis/dns.gandi.creeper.tw.sh
RECORD=r53

#=================================
bc=/home/sita/script/minecraft/gcloud/bc

#=================================
[ -z "$gcloud_account" ] && gcloud_account="sita@changen.com.tw"
[ -z "$project" ] && project="creeper-199909"
[ -z "$instances" ] && instances="bungeecord-tw2"
last_account=$(get_account)

#=================================
set_machine_type() {
    type=$1
    cpu=$2
    memory=$3

    set_account $gcloud_account
    
    case "$type" in
      "micro")
        echo == Set $instances Machine Type to f1-micro
        gcloud compute instances set-machine-type $instances --machine-type "f1-micro"
        ;;
      "small")
        echo == Set $instances Machine Type to g1-small
        gcloud compute instances set-machine-type $instances --machine-type "g1-small"
        ;;
      "custom")
        echo == Set $instances Machine Type to $type cpu=$cpu memory=${memory}GB
        gcloud compute instances set-machine-type $instances --custom-cpu=$cpu --custom-memory=$memory
        ;;
      *)
        echo == Set $instances Machine Type to $type
        gcloud compute instances set-machine-type $instances --machine-type $type
    esac
    
    set_account $last_account
}

#=================================
start_machine() {
    echo == Start Machine $instances
    gcloud --account $gcloud_account --project $project compute instances start $instances
}

#=================================
stop_machine() {
    echo == Stop Machine $instances
    gcloud --account $gcloud_account --project $project compute instances stop $instances
}

#=================================
lookup_dns_ip() {
  host "$1" | sed -rn 's@^.* has address @@p'
}

#=================================
dns_bctw_remove() {
    $bc stop
}

#=================================
dns_home() {
    echo DNS Groups: $(basename $0)
	
	echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip gem.creeper.tw)
	bcip+=" "

	$gandi set $RECORD $bcip
}

###
case "$1" in
  start)
    [ ! -z "$2" ] && set_machine_type $2 $3 $4
    start_machine
    ;;
  stop)
    stop_machine
    [ "$instances" == "bungeecord-tw2" ] && dns_bctw_remove
    [ "$instances" == "bungeecord-tw2" ] && dns_home
    ;;
  set)
    [ ! -z "$2" ] && set_machine_type $2 $3 $4
    ;;
  *)
    start_machine
esac

