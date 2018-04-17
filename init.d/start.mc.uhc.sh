#!/bin/bash

. /home/sita/script/minecraft/alias.minecraft
. /home/sita/script/init.d/start.mc.sh

mcdns=uhc
hostnames=($mcdns)
servers=(s74)

run $*
