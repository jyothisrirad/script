#!/bin/bash

#=================================
. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/persistent
. /home/sita/script/include/bashlock.sh
. /home/sita/script/minecraft/alias.minecraft

#=================================
gandi=/home/sita/script/mis/dns.gandi.creeper.tw.sh
RECORD=r53

#=================================
# setmachine=/home/sita/script/minecraft/gcloud/setmachine.sh
bc1=/home/sita/script/minecraft/gcloud/bungeecord.sh
bc3=/home/sita/script/minecraft/gcloud/igroup3.sh
ppl_per_bc=10
# ppl_to_start_bc=15
[ $(date +%u) -lt '5' ] && ppl_to_start_bc=10 || ppl_to_start_bc=15
bctw="bungeecord-tw2"
bctw_prestop_time="2255"
bctw_stop_time="2300"

#=================================
lockfile=/tmp/$(basename $0)

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
#=================================
is_same_dns_group() {
    group=$1
    echo -e DNS Groups: ${GREEN}$group ${NC}
    
	eval "$(dbload 'dnsgroup')"
    
    key="group"
    keyhash=$(string_hash $key)
    
    [ ! -z "${dnsgroup[keyhash]}" ] && group_last=${dnsgroup[keyhash]}
    
    [ "$group_last" == "$group" ] && return 0
    
    dnsgroup[keyhash]=$group
        
	[ ! -z "${!dnsgroup[*]}" ] && dbsave "dnsgroup" "$(declare -p dnsgroup)"
    
    return 1
}
#=================================
update_dns_bcgroups() {
	# do not return, becuase ip may change
	is_same_dns_group "bcgroups"
	
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
update_dns_bchome() {
    is_same_dns_group "bchome" && return
	
	echo -e Collecting ip: ${GREEN}"bc.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip bc.creeper.tw)
	bcip+=" "
	
	echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip gem.creeper.tw)
	bcip+=" "

	$gandi set $RECORD $bcip
}

#=================================
update_dns_home() {
    is_same_dns_group "home" && return
	
	echo -e Collecting ip: ${GREEN}"gem.creeper.tw"${NC}
	bcip+=$(lookup_dns_ip gem.creeper.tw)
	bcip+=" "

	$gandi set $RECORD $bcip
}

#=================================
num_player_or_exit() {
	lock $lockfile
    count=$(bungee_command_noecho glist showall | grep player | awk '{print $3}')
	unlock $lockfile
    
    re='^[0-9]+$'
    ! [[ $count =~ $re ]] && exit
    
    echo $count
}

#=================================
update_dns() {
	echo == update_dns
    ppl_count=$(num_player_or_exit)
	echo -e Online Players: ${GREEN}$ppl_count${NC}
	[ -z "$ppl_count" ] && return
    [ "$ppl_count" -gt "$ppl_to_start_bc" ] && update_dns_bcgroups && return
    [ $(date +%H%M) -lt "$bctw_prestop_time" ] && update_dns_bchome && return
    update_dns_home
}

#=================================
dns_check_install() {
	addto_crontab "#gcloud DNS update $(basename $0)"
    addto_crontab "* * * * * /bin/bash $(readlink -e $0) dnsupdate"
}

#=================================
dns_check_remove() {
    delfrom_crontab "$(basename $0)"
}

#=================================
#=================================
bctw_stop_check() {
    [ $(date +%H%M) -lt "$bctw_stop_time" ] && return
    
	echo == bctw_stop_check
    
	lock $lockfile
	pcounts=$(proxy_list | grep "proxy $bctw" | awk '{print $3}')
	unlock $lockfile
    
    echo -e Online Players on $bctw: ${GREEN}$pcounts ${NC}
    [ -z "$pcounts" ] && return
    [ "$pcounts" == '0' ] && echo -e == bctw_stop_check: ${GREEN}bc1 stop${NC} && $bc1 stop && redis_remove_heartbeats
}

#=================================
#=================================
num_player_on_bcgroup_or_exit() {
	lock $lockfile
	pcounts=$(proxy_list | grep proxy | grep -E "(-[0-9a-z]{4})" | awk '{print $3}')
	unlock $lockfile

	count=0
	for ppl in $pcounts;
	do
		count=$(echo $count+$ppl|bc)
	done
    
    re='^[0-9]+$'
    ! [[ $count =~ $re ]] && exit

	echo $count
}

#=================================
redis_remove_heartbeats() {
	echo == redis_remove_heartbeats
	redis-cli -h redis.creeper.tw -a 'creeper!234' del heartbeats
}

#=================================
ppl_less() {
    [ $(num_bcgroup_on) == '0' ] && return
    
	eval "$(dbload 'ppl_less')"
    
    key="bc_ppl_count"
    keyhash=$(string_hash $key)
    [ -z "${ppl_less[keyhash]}" ] && ppl_less[keyhash]=0
    
    bc_ppl_count_last=${ppl_less[keyhash]}
    bc_ppl_count=$(num_player_on_bcgroup_or_exit)
    echo == ppl_less
    echo -e Online Players on bgroup last time: ${YELLOW}$bc_ppl_count_last ${NC}
	echo -e Online Players on bgroup: ${GREEN}$bc_ppl_count ${NC}
	
	# [ "$bc_ppl_count_last" == "$bc_ppl_count" ] && echo Online Players on bgroup did not change
	[ "$bc_ppl_count_last" == "$bc_ppl_count" ] && return
	
    ppl_less[keyhash]=$bc_ppl_count
        
	[ ! -z "${!ppl_less[*]}" ] && dbsave "ppl_less" "$(declare -p ppl_less)"
	
    # [ "$bc_ppl_count" == '0' ] && echo ppl_less: \*\*\* bctemp stop \*\*\*
    [ "$bc_ppl_count" == '0' ] && echo -e == ppl_less: ${GREEN}bc3 stop${NC} && $bc3 stop && redis_remove_heartbeats
}

#=================================
#=================================
num_bcgroup_on() {
	lock $lockfile
	bcount=$(proxy_list | grep proxy | grep -E "(-[0-9a-z]{4})" | wc -l)
	unlock $lockfile

	echo $bcount
}

#=================================
ppl_more() {
	# eval "$(dbload 'ppl_more')"
    
    # key="ppl_count"
    # keyhash=$(string_hash $key)
    # [ -z "${ppl_more[keyhash]}" ] && ppl_more[keyhash]=0
    
    # ppl_count_last=${ppl_more[keyhash]}
    ppl_count=$(num_player_or_exit)
    echo == ppl_more
    # echo -e Online Players last time: ${YELLOW}$ppl_count_last ${NC}
	echo -e Online Players: ${GREEN}$ppl_count ${NC}
	
    # ppl_more[keyhash]=$ppl_count
        
	# [ ! -z "${!ppl_more[*]}" ] && dbsave "ppl_more" "$(declare -p ppl_more)"
    
	[ -z "$ppl_count" ] && return
    [ "$ppl_count" -le "$ppl_to_start_bc" ] && return
	ppl_count=$(echo $ppl_count-$ppl_per_bc|bc)
	
	bcount=$(num_bcgroup_on)
	echo -e bcgroup count: ${GREEN}$bcount ${NC}
	bcsuggest=$(echo \($ppl_count+$ppl_per_bc-1\)/$ppl_per_bc|bc)
	echo -e bcgroup suggest: ${GREEN}$bcsuggest ${NC}
	[ $bcsuggest -gt $bcount ] && echo -e == ppl_more: ${GREEN}bc3 start $bcsuggest ${NC} && $bc3 start $bcsuggest $bcsuggest
}

#=================================
#=================================
watch_player_count() {
    echo === run every min && update_dns && bctw_stop_check
	[ $(echo $(date +%M)%2|bc) == '0' ] && echo === run every 2 min && ppl_less
	[ $(echo $(date +%M)%3|bc) == '0' ] && echo === run every 3 min && ppl_more
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
    # $0 install
    # start_bc
    $bc1 start small
	$bc3 start $2 $2
    update_dns_bcgroups
    # dns_check_install
    exit
    ;;
  prestop)
    # $0 remove
    update_dns_bchome
    ;;
  stop)
    # $0 remove
	$bc3 stop
    update_dns_bchome
    # dns_check_remove
	redis_remove_heartbeats
    exit
    ;;
  stop2)
    # stop_bc
    $bc1 stop
	$0 stop
	update_dns_home
    ;;
  watch)
    watch_player_count
    ;;
  more)
    ppl_more
    ;;
  less)
    ppl_less
    ;;
  logrotate)
    logrotate
    ;;
  *)
    watch_player_count
esac

