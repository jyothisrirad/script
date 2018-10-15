#!/bin/bash

. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

gcloud_account=$1
instances=$2
type=$3
custom_cpu=$4
custom_memory=$5

#=================================
# last_account=$(get_account)
# set_account $gcloud_account
# gcloud compute instances set-machine-type $instances --machine-type $type
# set_account $last_account
set_machine_type() {
    type=$1
    cpu=$2
    memory=$3

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
      "custom")
        echo == Set $instances Machine Type to $type cpu=$cpu memory=${memory}GB
        gcloud compute instances set-machine-type $instances --custom-cpu=$cpu --custom-memory=$memory
        ;;
      *)
        echo == Set $instances Machine Type to $type
        gcloud compute instances set-machine-type $instances --machine-type $type
    esac
    
    set_account $last_account
}

set_machine_type $type $custom_cpu $custom_memory
