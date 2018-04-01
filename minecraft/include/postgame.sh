#!/bin/bash

. /home/sita/script/minecraft/include/java_args.sh

USERNAME="sita"
ZIPDIR=/mnt/backup
BACKUPPATH="/mnt/backup"
# JARFILE="minecraft_server.1.12.2.jar"
JARFILE=$(find . -maxdepth 1 -name '*.jar')
LOG="$MCPATH/logs/latest.log"
OPTMEM="-Xmx2G"
JAVAARGS="$OPTMEM $OPTGC $OPTLOG"

#
LOOPSTOP="/mnt/runtimes/$mcver/logs/loopstop"
INVOCATION="$MCPATH/loop.sh"
# INVOCATION="$MCPATH/start.sh"
# HOUSEKEEP=="$MCPATH/housekeeping.sh"

#
pre_game_setup() {
	echo [pre_game_setup]
	# rm -rf $DP0/plugins/Buscript/scripts/scripts.bin
    # HOUSEKEEP install
    rm -rf $DP0/world*
    # rm -rf $DP0/orebfuscator_cache
    rm -rf $DP0/crash-reports
    cp -rf $DP0/GameWorld $DP0/world
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
cat >server.properties <<EOL
allow-flight=false
allow-nether=false
enable-command-block=true
gamemode=2
level-name=world
online-mode=false
op-permission-level=2
snooper-enabled=false
spawn-protection=0
white-list=false
EOL
