#!/bin/bash

. /home/sita/script/include/common_helper

###
[ -z "$gcloud_account" ] && gcloud_account="sita@changen.com.tw"
[ -z "$project" ] && project="creeper-199909"
[ -z "$instances" ] && instances="uhc-tw2"

[ -z "$2" ] && . /home/sita/script/minecraft/gcloud/bungeecord.sh $1 custom 4 8
[ ! -z "$2" ] && . /home/sita/script/minecraft/gcloud/bungeecord.sh $*
