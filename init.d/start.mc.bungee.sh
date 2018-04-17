#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
. /home/sita/script/init.d/start.mc.sh

mcdns=tw1
hostnames=($mcdns)
servers=(s32 s65)

run $*
