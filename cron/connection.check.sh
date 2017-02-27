#!/bin/sh

BASEDIR=$(dirname $0)
gateway=$(ip r | grep default | cut -d ' ' -f 3)
dns=8.8.8.8
badconnflag=/tmp/$(basename $0).badconnection
lastonflag=/tmp/$(basename $0).lastonflag
onmin=340
# no_reset_hour_start=8
# no_reset_hour_stop=14
no_reset_hour_start=8
no_reset_hour_stop=8

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

# testhost() {
	# if ping -q -c 1 -W 1 $1 >/dev/null; then
	  # echo ping $1, exitcode is $?
	  # return $?
	# fi
# }

testhost() {
	ping -q -c 1 -W 1 $1 >/dev/null; ret=$?
	# echo ping $1, exitcode: $ret
	return $ret
	
	# if [ "$ret" -eq "0" ]; then
		# echo $ret=="0", returning 0
		# return 0
	# else
		# echo $ret!="0", returning 1
		# return 1
	# fi
}

reset_gateway() {
	expect -f $BASEDIR/gateway.reboot.sh
	rm $lastonflag
}

connection_check() {
	# if ! testhost2 192.168.1.250; then
		# echo false	
	# else
		# echo true
	# fi
	
	# if ! testhost2 192.168.1.251; then
		# echo false	
	# else
		# echo true
	# fi

	if ! testhost $gateway; then
		echo gateway disconnected, badconnflag created.
		touch $badconnflag 
	else 
		echo gateway connected
		
		if [ -e $badconnflag ] || ! testhost $dns; then 
			echo badconnflag found or internet disconnected, reset gateway.
			reset_gateway
			rm $badconnflag
		else 
			echo internet connected
			
			if [ ! -e $lastonflag ]; then 
				echo lastonflag created.
				touch $lastonflag
			else
				now_hour=$(date +%H)
				now_min=$(date +%M)
				
				if [ "$no_reset_hour_start" -lt "$now_hour" ] && [ "$now_hour" -lt "$no_reset_hour_stop" ]; then
					echo "$no_reset_hour_start < $now_hour < $no_reset_hour_stop", no reset
				elif [ "$now_min" -eq 0 ] && test `find "$lastonflag" -mmin +$onmin`; then
					echo lastonflag is old enough, reset gateway.
					reset_gateway				
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


