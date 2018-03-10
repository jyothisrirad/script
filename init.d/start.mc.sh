#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft

s74 && mcserver start

/home/sita/script/mis/gcloud.dns.update.sh creeper-tw creeper.tw tw1 5min
