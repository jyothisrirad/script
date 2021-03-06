#!/bin/bash

. /home/sita/script/include/common_helper
. /home/sita/script/minecraft/alias.minecraft

mcdomain=creeper.tw
mchub=gem.${mcdomain}
mchubport=20668
USERNAME=sita

as_user() {
  if [ "$(whoami)" == "$USERNAME" ] ; then
    bash -c "$1"
  else
    su - $USERNAME -c "$1"
  fi
}

mcstart_nocheck() {
    [ ! -z $rematch ] && gcsfuse --key-file /home/sita/.gcloud/chsliu@gmail.com.json creeper-tw-backup /mnt/backup
    
	for srv in ${servers[*]}
	do
		chmc ${!srv}
        [ ! -z $rematch ] && echo -e "${GREEN}=== Restoring $mcver ${NC}" && mcserver pre_restore && mcserver restore
		[ -n "$(type -t custom_function)" ] && [ "$(type -t custom_function)" = function ] && echo -e "${GREEN}=== $mcver custom_function ${NC}" && custom_function
        [ -f update.sh ] && echo -e "${GREEN}=== $mcver/update.sh ${NC}" && as_user "./update.sh"
		server.prep
        mcserver start
		server.post
	done
}

mcstart() {
    while [ 1 ]; do
        if is_my_ip_match_to_dns ${dns_external}.${mcdomain}; then
            echo -e "${GREEN}[$(date +%H:%M:%S)] === ${dns_external}.${mcdomain} DNS and current IP matched ${NC}"
            if testconnect $mchub $mchubport; then
                echo -e "${GREEN}[$(date +%H:%M:%S)] === ${mchub}:${mchubport} Hub connected ${NC}"
                echo -e "${GREEN}[$(date +%H:%M:%S)] === Starting Minecraft Server ${NC}"
                break
            else
                echo -e "${RED}[$(date +%H:%M:%S)] === ${mchub}:${mchubport} Hub not connected ${NC}"
            fi
        else
            echo -e "${RED}[$(date +%H:%M:%S)] === ${dns_external}.${mcdomain} DNS and current IP not matched ${NC}"
        fi
        waiting 10
    done

    mcstart_nocheck
}

start() {
	# make sure related kernal variable is set
    echo -e "${GREEN}=== sysctl ${NC}"
	sudo sysctl --system
	# echo 5120 | sudo tee /sys/module/nf_conntrack/parameters/hashsize
	
    echo -e "${GREEN}=== gitsync ${NC}"
    cd /home/sita/script && as_user "./gitsync.sh"
	
	[ ! -z $antiddos ] && echo -e "${GREEN}=== iptables ${NC}" && sudo ~/script/mis/iptables.antiddos.sh | sudo tee /etc/iptables.conf
    
    for h in ${dns_updates[*]}; do
        runscript=/home/sita/script/minecraft/gcloud/$h
		[ ! -f $runscript ] && runscript=/home/sita/script/minecraft/gcloud/default
        [ -f $runscript ] && ( echo -e "${GREEN}=== Starting gcloud dns for $h.${mcdomain} script: ${YELLOW}$(basename $runscript) ${NC}"; as_user "$runscript start" )
    done
    
    is_my_ip_match_to_dns ${mchub} && autostart=1
    [ ! -z $rematch_hour ] && [ $(date +%H) == $rematch_hour ] && autostart=1 && rematch=1
    [ ! -z $autostart ] && ( echo -e "${GREEN}=== autostart:${YELLOW} mcstart_nocheck ${NC}"; mcstart_nocheck ) || echo -e "${GREEN}=== to manual start server:${YELLOW} $0 mcstart ${NC}"
}

stop() {
    for h in ${dns_updates[*]}; do
        runscript=/home/sita/script/minecraft/gcloud/$h
        [ -f $runscript ] && ( echo -e "${GREEN}=== Stopping gcloud dns for $h.${mcdomain} script: ${YELLOW}$(basename $runscript) ${NC}"; as_user "$runscript stop" )
    done
    
	for srv in ${servers[*]}
	do
		chmc ${!srv} && mcserver halt
	done
}

stop2() {
	for srv in ${servers2[*]}
	do
		chmc ${!srv} && mcserver halt
	done
}

checklag() {
	for srv in ${servers[*]}
	do
		echo -e ${YELLOW}mcver=$mcver${NC}
		chmc ${!srv} && logs | grep.lag
	done
}

checkclag() {
	for srv in ${servers[*]}
	do
		echo -e ${YELLOW}mcver=$mcver${NC}
		chmc ${!srv} && logs | grep '服務器'
	done
}

is_my_ip_match_to_dns() {
    # echo Checking $1
    my_ip=$(curl -s https://api.ipify.org)
    matching_dns=$(dig $1 | grep IN | grep -v ";" | awk '{ printf ("%s\n", $5) }')
    # echo $my_ip $matching_dns
    [ "$my_ip" == "$matching_dns" ] && return 0 || return 1
}

waiting() {
    waitmax=${1:-10}
    printf "[$(date +%H:%M:%S)] Waiting"
    for ((i=1;i<=${waitmax};i++)); do
        printf "."
        sleep 1
    done
    printf "\n"
}

testconnect() {
    addr=$1
    port=$2
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/$addr/$port"
    return $?
}

run() {
    case "$1" in
        start)
            start
            ;;
        mcstart)
            mcstart
            ;;
        stop)
            stop
            ;;
        stop2)
            stop2
            ;;
        restart)
            stop
            start
            ;;
        lag)
            checklag
            ;;
        clag)
            checkclag
            ;;
        *)
            echo "Usage: $0 {start|mcstart|stop|stop2|restart|lag|clag}"
    esac
}
