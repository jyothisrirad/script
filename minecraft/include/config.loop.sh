#!/bin/bash

. /home/sita/script/minecraft/include/java_args.sh
. /home/sita/script/minecraft/alias/admin.1.help
. /home/sita/script/minecraft/alias/admin.server

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
LOOPSTOP="/mnt/runtimes/$mcver/logs/loopstop"
INVOCATION="$MCPATH/loop.sh"
# INVOCATION="$MCPATH/start.sh"
# HOUSEKEEP="$MCPATH/housekeeping.sh"

#
pre_game_setup() {
	echo [pre_game_setup]
	server.prep
    [ -f $HOUSEKEEP ] && $HOUSEKEEP install
	
    rm -rf $DP0/crash-reports
    rm -rf $DP0/timings
    rm -rf $DP0/world*
    cp -rf $DP0/GameWorld $DP0/world
	echo [pre_game_setup][end]
}

post_game_setup() {
	echo [post_game_setup]
    [ -f $HOUSEKEEP ] && $HOUSEKEEP remove
	server.post
	echo [post_game_setup][end]
}

# op-permission-level=4
# 設定OP的權限等級
# 1 - OP可以無視重生點保護。
# 1 - OP可以無視spawn保護。
# 2 - OP可以使用單人遊戲作弊指令（除了/publish，因為不能在伺服器上使用，/debug也是）並使用指令方塊。指令方塊和領域服服主/管理員有此等級權限。
# 2 - OPS可以使用/clear,  /difficulty, /effect, /gamemode, /gamerule, /give, /tp指令，並且可以編輯命令方塊(伺服器預設禁用)。
# 3 - OP可以使用幾乎所有多人遊戲限定的指令（除第4級專用指令）
# 3 - OP 可以使用/ban, /deop,  /kick, and /op指令。
# 4 - OP可以使用所有指令，包括/stop、/save-all、/save-on和/save-off。
# 4 - OP可以於遊戲中使用/stop。

# export ZIPDIR
read -r -d '' server_properties <<- EOM
allow-flight=false
allow-nether=false
enable-command-block=true
gamemode=2
level-name=world
level-type=DEFAULT
online-mode=false
op-permission-level=2
snooper-enabled=false
spawn-protection=0
white-list=false
prevent-proxy-connections=true
EOM
