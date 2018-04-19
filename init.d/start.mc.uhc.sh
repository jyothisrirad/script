#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
. /home/sita/script/init.d/start.mc.sh

dns_external=uhc
dns_updates=($mcdns)
servers=(s74)

run $*
