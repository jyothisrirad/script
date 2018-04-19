#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
. /home/sita/script/init.d/start.mc.sh

dns_external=tw1
dns_updates=($mcdns)
servers=(s32 s65)

run $*
