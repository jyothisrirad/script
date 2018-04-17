#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
servers=(s74)

mcstart() {
	for srv in ${servers[*]}
	do
		$srv && mcserver start
	done
}

start() {
    cd ~/script && ./gitsync.sh
    
	# /home/sita/script/minecraft/gcloud/uhc
    
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
