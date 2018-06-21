#!/bin/bash

. /home/sita/script/include/common_helper

###
[ -z "$ig_account" ] && ig_account=creeper.workshop@gmail.com
[ -z "$ig_project" ] && ig_project=creeperworkshop-web
[ -z "$ig_region" ] && ig_region=asia-east1
# [ -z "$instances_group" ] && instances_group=bc
[ -z "$instances_group_region" ] && instances_group_region=bc3
[ -z "$instances_count_min" ] && instances_count_min=1
[ -z "$instances_count_max" ] && instances_count_max=9
[ -z "$HOSTS" ] && HOSTS=r33

. /home/sita/script/minecraft/gcloud/igroup.sh $*
