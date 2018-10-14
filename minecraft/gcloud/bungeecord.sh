#!/bin/bash

. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

gcloud_account="sita@changen.com.tw"
project="creeper-199909"
instances="bungeecord-tw2"
last_account=$(get_account)

###
set_machine_type() {
    type=$1

    set_account $gcloud_account
    
    case "$type" in
      "micro")
        echo == Set $instances Machine Type to f1-micro
        gcloud compute instances set-machine-type $instances --machine-type "f1-micro"
        ;;
      "small")
        echo == Set $instances Machine Type to g1-small
        gcloud compute instances set-machine-type $instances --machine-type "g1-small"
        ;;
      *)
        echo == Set $instances Machine Type to $type
        gcloud compute instances set-machine-type $instances --machine-type $type
    esac
    
    set_account $last_account
}

start_machine() {
    echo == Start Machine $instances
    gcloud --account $gcloud_account --project $project compute instances start $instances
}

stop_machine() {
    echo == Stop Machine $instances
    gcloud --account $gcloud_account --project $project compute instances stop $instances
}

###
case "$1" in
  start)
    [ ! -z "$2" ] && set_machine_type $2
    start_machine
    ;;
  stop)
    stop_machine
    ;;
  *)
    start_machine
esac

