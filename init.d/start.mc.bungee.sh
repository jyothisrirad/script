#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

mcdns=tw1
mchub=tp1.creeper.tw
mchubport=20468
hostnames=($mcdns)
servers=(s32 s65)

mcstart() {
	for srv in ${servers[*]}
	do
		$srv && mcserver start
	done
}

start() {
    cd ~/script && ./gitsync.sh
  
	/home/sita/script/minecraft/gcloud/$mcdns
    
    # mcstart
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
    # echo $myip $mydns
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
                echo === IP and DNS matched
                if testconnect $mchub $mchubport; then
                    echo === Hub connected
                    echo === Starting Minecraft Server
                    break
                fi
            else
                echo IP and DNS not matched
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
