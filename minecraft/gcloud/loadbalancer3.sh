#!/bin/bash

###
[ -z "$lb_account" ] && lb_account=creeper.workshop@gmail.com
[ -z "$PROJECT" ] && PROJECT=creeperworkshop-web
[ -z "$POOL" ] && POOL=lb3
[ -z "$LB" ] && LB=$POOL
[ -z "$instances_group_region" ] && instances_group_region=bc3

###
[ -z "$igctrl" ] && igctrl=/home/sita/script/minecraft/gcloud/igroup3.sh

###
. /home/sita/script/minecraft/gcloud/loadbalancer.sh $*
