#!/bin/bash

json_encoding() {
    IFS='%'
    echo $(echo $*|uni2ascii -a U -q)
    unset IFS
}

JARFILE="spigot-1.12.2.jar"
OPTMEM="-Xmx1G"
OPTGC="-XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=45 -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=50 -XX:+AggressiveOpts"
OPTPAGE="-XX:LargePageSizeInBytes=2M -XX:+UseLargePages -XX:+UseLargePagesInMetaspace"
[ ! -z $mc_debug_mode ] && OPTLOG="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=9 -XX:GCLogFileSize=1M -Xloggc:logs/memory.log"

# [ $(date +%A) == 'Saturday' ] && 
# -Dusing.aikars.flags=mcflags.emc.gs 
# -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:G1HeapRegionSize=16M
# -XX:PermSize=128m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+UseNUMA -XX:+CMSParallelRemarkEnabled -XX:+UseAdaptiveGCBoundary -XX:-UseGCOverheadLimit -XX:+UseBiasedLocking -XX:SurvivorRatio=8 -XX:MaxTenuringThreshold=15 -XX:UseSSE=3 -XX:+UseLargePages -XX:+UseFastAccessorMethods -XX:+UseStringCache -XX:+UseCompressedStrings -XX:+UseCompressedOops -XX:+OptimizeStringConcat 

JAVAARGS="$OPTMEM $OPTGC $OPTLOG"
