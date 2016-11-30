BASEDIR=$(dirname $0)
HOSTIP=$(getent hosts openelec | awk '{ print $1 }')

target=$1

count=$( ping -c 1 $target | grep ttl | wc -l )

if [ ! $count -eq 0 ]
#if [ "`ping -c 1 $1`" ]
then
  if [ ! -f /tmp/isonline.$1 ]
  then 
    rm -f /tmp/isoffline.$1 
    touch /tmp/isonline.$1
    #echo 1
    #echo Online ${BASEDIR}/pushbullet/pushbullet_cmd.py
    ${BASEDIR}/pushbullet/pushbullet_cmd.py UR97NWpn7i61jqO0BQkyZWQhaNmfGe8t note ufjW6eNsjz3KRxFVWm "$1($HOSTIP) Online" ""
  fi
else
  if [ ! -f /tmp/isoffline.$1 ]
  then 
    rm -f /tmp/isonline.$1 
    touch /tmp/isoffline.$1
    #echo 0
    #echo Offline ${BASEDIR}/pushbullet/pushbullet_cmd.py
    ${BASEDIR}/pushbullet/pushbullet_cmd.py UR97NWpn7i61jqO0BQkyZWQhaNmfGe8t note ufjW6eNsjz3KRxFVWm "$1($HOSTIP) Offline" ""
  fi
fi
