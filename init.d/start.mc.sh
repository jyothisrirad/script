#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

mchub=tp1.creeper.tw
mchubport=20468
mcdns=uhc
hostnames=($mcdns)
servers=(s74)

mcstart() {
	for srv in ${servers[*]}
	do
		$srv && mcserver start
	done
}

start() {
    echo -e "${GREEN}=== gitsync ${NC}"
    cd ~/script && ./gitsync.sh
    
    for h in $hostnames; do
        echo -e "${GREEN}=== gcloud dns for $h ${NC}"
        /home/sita/script/minecraft/gcloud/$h
    done
    
    checkip tp1 && ( echo -e "${GREEN}=== mcstart for home server ${NC}"; mcstart )
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

checkip() {
    # echo Checking $1
    thisip=$(curl -s https://api.ipify.org)
    thisdns=$(dig $1.creeper.tw | grep IN | grep -v ";" | awk '{ printf ("%s\n", $5) }')
    # echo $thisip $thisdns
    [ $thisip == $thisdns ] && return 0 || return 1
}

waiting() {
    waitmax=${1:-10}
    printf "Waiting"
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

case "$1" in
	start)
		start
		;;
	mcstart)
        while [ 1 ]; do
            if checkip $mcdns; then
                echo -e "${GREEN}=== IP and DNS matched ${NC}"
                if testconnect $mchub $mchubport; then
                    echo -e "${GREEN}=== Hub connected ${NC}"
                    echo -e "${GREEN}=== Starting Minecraft Server ${NC}"
                    break
                fi
            else
                echo -e "${RED}=== IP and DNS not matched ${NC}"
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
