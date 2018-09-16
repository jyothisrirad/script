#!/bin/bash

usage() {
	echo $0 [username] [userid] [newid]
}

change_userid() {
	user=$1
	group=$1
	oldID=$2
	newID=$3
	sudo usermod -u $newID $user
	sudo groupmod -g $newID $group
	sudo find / -user $oldID -exec chown $newID {} \;
	sudo find / -group $oldID -exec chgrp $newID {} \;
}

[ -z $1 ] && usage && exit
[ -z $2 ] && usage && exit
[ -z $3 ] && usage && exit
change_userid $1 $2 $3
