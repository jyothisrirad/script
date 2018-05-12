#!/bin/bash

. /home/sita/script/minecraft/include/java_args.sh

USERNAME="sita"
[ ! -z ${RUNINRAM+x} ] && MCPATH="/tmp/${VERSION}_DIR" || MCPATH=${MCSTORE}
ZIPDIR=/mnt/backup
BACKUPPATH="/mnt/backup"
# JARFILE="minecraft_server.1.12.2.jar"
JARFILE=$(basename $(find . -maxdepth 1 -name '*.jar' | head -n 1) 2>/dev/null)
LOG="$MCPATH/logs/latest.log"
OPTMEM="-Xmx2G"
JAVAARGS="$OPTMEM $OPTGC $OPTLOG"

#
NEWJAR=$BACKUPPATH/server/$JARFILE
[ -f $NEWJAR ] && rsync -az $NEWJAR .

#
# LOOPSTOP="/mnt/runtimes/$mcver/logs/loopstop"
# INVOCATION="$MCPATH/loop.sh"
INVOCATION="$MCPATH/start.sh"
# HOUSEKEEP=="$MCPATH/housekeeping.sh"

#
pre_game_setup() {
	echo [pre_game_setup]
	# rm -rf $DP0/plugins/Buscript/scripts/scripts.bin
    # HOUSEKEEP install
    # rm -rf $DP0/orebfuscator_cache
    # rm -rf $DP0/crash-reports
    rm -rf $DP0/timings
    # rm -rf $DP0/world*
    # cp -rf $DP0/GameWorld $DP0/world
	echo [pre_game_setup][end]
}

post_game_setup() {
	echo [post_game_setup]
	# /tmp/$mcver log list
	# /tmp/$mcver log teams
	# /tmp/$mcver log slain
	# /tmp/$mcver log winner
	# /tmp/$mcver log lag
	# /tmp/$mcver backup
	# /tmp/$mcver save off
    # HOUSEKEEP remove
	echo [post_game_setup][end]
}

# op-permission-level=4
# 1 - OP可以無視spawn保護。
# 2 - OPS可以使用/clear,  /difficulty, /effect, /gamemode, /gamerule, /give, /tp指令，並且可以編輯命令方塊(伺服器預設禁用)。
# 3 - OP 可以使用/ban, /deop,  /kick, and /op指令。
# 4 - OP可以於遊戲中使用/stop。

# export ZIPDIR
read -r -d '' server_properties <<- EOM
# allow-nether=false
# gamemode=2
# spawn-protection=0
allow-flight=false
enable-command-block=true
level-name=world
level-type=DEFAULT
online-mode=false
op-permission-level=2
snooper-enabled=false
white-list=false
EOM
