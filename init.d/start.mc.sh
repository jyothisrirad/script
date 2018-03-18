#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
servers=(s74)

start() {
	for srv in ${servers[*]}
	do
		$srv && mcserver start
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

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    start
esac
