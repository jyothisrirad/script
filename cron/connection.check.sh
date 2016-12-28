#!/bin/sh

BASEDIR=$(dirname $0)
gateway=$(ip r | grep default | cut -d ' ' -f 3)
dns=8.8.8.8
badconnflag=/tmp/$(basename $0).badconnection
lastonflag=/tmp/$(basename $0).lastonflag
onmin=240
no_reset_hour_start=8
no_reset_hour_stop=14

crontab_status() {
	status=$(crontab -l)
	return $?
}

addto_crontab() {
	cronfile=/var/spool/cron/crontabs/$(whoami)

	if ! crontab_status; then
		echo "" | sudo tee -a $cronfile
		sudo chown $(whoami):crontab $cronfile
	fi
	
	if ! sudo grep -Fxq "$*" $cronfile; then
		echo "$*" | sudo tee -a $cronfile
	fi
}

delfrom_crontab() {
	cronfile=/var/spool/cron/crontabs/$(whoami)

	line=$*
	line=$(echo "$line" | sed 's/\//\\\//g')
	sudo sed -i "/$line/d" $cronfile
}

testhost() {
	if ping -q -c 1 -W 1 $1 >/dev/null; then
	  return $?
	fi
}

connection_check() {
	if ! testhost $gateway; then
		echo gateway disconnected, badconnflag created.
		touch $badconnflag 
	else 
		echo gateway connected
		
		if [ -e $badconnflag ] || ! testhost $dns; then 
			echo badconnflag found or internet disconnected, reset gateway.
			expect -f $BASEDIR/gateway.reboot.sh
			rm $lastonflag
			rm $badconnflag
		else 
			echo internet connected
			
			if [ ! -e $lastonflag ]; then 
				echo lastonflag created.
				touch $lastonflag
			else
				# hour_lastonflag=$(ls -la $lastonflag | cut -d ' ' -f 8 | cut -d ':' -f 1)
				hour_now=$(date +%H)
				
				if [ "$no_reset_hour_start" -le "$hour_now" ] && [ "$hour_now" -lt "$no_reset_hour_stop" ]; then
					echo "$no_reset_hour_start <= $hour_now < $no_reset_hour_stop", no reset
				elif test `find "$lastonflag" -mmin +$onmin`; then
					echo lastonflag is old enough, reset gateway.
					expect -f $BASEDIR/gateway.reboot.sh
					rm $lastonflag				
				fi
			fi
		fi
	fi
}

case "$1" in
  install)
	addto_crontab "#connection check"
	addto_crontab "*/10 * * * * $(readlink -e $0)"
	;;
  uninstall)
	delfrom_crontab "#connection check"
	delfrom_crontab "$0"
	;;
  *)
  connection_check
  ;;
esac


