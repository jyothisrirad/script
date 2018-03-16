#!/bin/bash

start() {
###
. /home/sita/script/minecraft/alias.minecraft

s74 && mcserver start

###
/home/sita/script/minecraft/gcloud/uhc
}

stop() {
. /home/sita/script/minecraft/alias.minecraft

s74 && mcserver halt
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
