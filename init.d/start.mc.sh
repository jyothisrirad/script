#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

mcdomain=creeper.tw
mchub=tp1.${mcdomain}
mchubport=20468
USERNAME=sita

as_user() {
  if [ "$(whoami)" == "$USERNAME" ] ; then
    bash -c "$1"
  else
    su - $USERNAME -c "$1"
  fi
}

mcstart() {
	for srv in ${servers[*]}
	do
		$srv && [ -f update.sh ] && echo -e "${GREEN}=== Running $mcver/update.sh${NC}" && ./update.sh
		$srv && mcserver start
	done
}

start() {
    echo -e "${GREEN}=== gitsync ${NC}"
    # cd /home/sita/script && su -c "./gitsync.sh" $USERNAME
    cd /home/sita/script && as_user "./gitsync.sh"
    
    for h in ${dns_updates[*]}; do
        runscript=/home/sita/script/minecraft/gcloud/$h
        # [ -f $runscript ] && ( echo -e "${GREEN}=== gcloud dns for $h.${mcdomain} ${NC}"; su -c "$runscript" $USERNAME )
        [ -f $runscript ] && ( echo -e "${GREEN}=== gcloud dns for $h.${mcdomain} ${NC}"; as_user "$runscript" )
    done
    
    is_my_ip_match_to_dns ${mchub} && ( echo -e "${GREEN}=== autorun mcstart for home server ${NC}"; mcstart ) || echo -e "${YELLOW}=== manual run $0 mcstart to start server ${NC}"
}

stop() {
	for srv in ${servers[*]}
	do
		$srv && mcserver halt
	done
}

checklag() {
	for srv in ${servers[*]}
	do
		$srv && logs | grep.lag
	done
}

checkclag() {
	for srv in ${servers[*]}
	do
		$srv && logs | grep '服務器'
	done
}

is_my_ip_match_to_dns() {
    # echo Checking $1
    my_ip=$(curl -s https://api.ipify.org)
    matching_dns=$(dig $1 | grep IN | grep -v ";" | awk '{ printf ("%s\n", $5) }')
    # echo $my_ip $matching_dns
    [ $my_ip == $matching_dns ] && return 0 || return 1
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
            mcstart
            ;;
        stop)
            stop
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
            start
    esac
}
