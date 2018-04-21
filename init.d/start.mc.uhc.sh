#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
. /home/sita/script/init.d/start.mc.sh

dns_external=uhc
dns_updates=($dns_external)
servers=(s74)
servers2=

run $*
