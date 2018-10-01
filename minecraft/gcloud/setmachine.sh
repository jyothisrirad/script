#!/bin/bash

. /home/sita/script/include/common_helper
. /home/sita/script/include/console.color
. /home/sita/script/include/gcloud_helper

gcloud_account=$1
instances=$2
type=$3

last_account=$(get_account)
set_account $gcloud_account
gcloud compute instances set-machine-type $instances --machine-type $type
set_account $last_account
