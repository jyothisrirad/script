#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

start() {
  s74 && mcserver start
  
  ###
  /home/sita/script/minecraft/gcloud/uhc
}

stop() {
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
