#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
servers=(s74)

start() {
    cd ~/script && ./gitsync.sh
    
	for srv in ${servers[*]}
	do
		echo $srv && mcserver start
	done
  
	###
	/home/sita/script/minecraft/gcloud/uhc
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
