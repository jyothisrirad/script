#!/bin/bash

###
. /home/sita/script/minecraft/alias.minecraft

s74 && mcserver start

###
HOST=uhc
/home/sita/script/mis/gcloud.dns.update.sh A creeper-tw $HOST creeper.tw 5min
# /home/sita/script/mis/gcloud.dns.update.sh CNAME creeper-tw mc creeper.tw $HOST.creeper.tw. 1min
