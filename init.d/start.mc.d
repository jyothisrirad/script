#!/bin/sh
### BEGIN INIT INFO
# Provides:          start.mc.d
# Required-Start:    
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       start minecraft server
### END INIT INFO

APP=$(hostname)
SCRIPT="/home/sita/script/mis/run_in_screen.sh /home/sita/script/init.d/hosts/$APP"
RUNAS=root

PIDFILE=/var/run/$APP.pid
LOGFILE=/var/log/$APP.log

start() {
  if [ -f /var/run/$APP.pid ] && kill -0 $(cat /var/run/$APP.pid); then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service…' >&2
  local CMD="$SCRIPT start &> \"$LOGFILE\" & echo \$!"
  # echo "$CMD"
  su -c "$CMD" $RUNAS > "$PIDFILE"
  echo 'Service started' >&2
}

stop() {
  # if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
    # echo 'Service not running' >&2
    # return 1
  # fi
  echo 'Stopping service…' >&2
  local CMD="$SCRIPT stop &> \"$LOGFILE\" & echo \$!"
  # echo "$CMD"
  # su -c "$CMD" $RUNAS > "$PIDFILE"
  $SCRIPT stop
  # kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

uninstall() {
  echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
  local SURE
  read SURE
  if [ "$SURE" = "yes" ]; then
    stop
    rm -f "$PIDFILE"
    echo "Notice: log file is not be removed: '$LOGFILE'" >&2
    update-rc.d -f $(basename $0) remove
    rm -fv "$0"
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    uninstall
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|uninstall}"
esac
