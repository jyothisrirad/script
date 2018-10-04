#!/bin/bash

#=================================
# help_hline3 'speedtest'

#=================================
make_filelist() {
    [ ! -d /tank ] && echo /tank does not exist && return
	
	file=~/$(hostname).filelist.txt
	[ -f $file ] && rm $file
	
	echo === >>$file
	echo CPU >>$file
	echo === >>$file
	cat /proc/cpuinfo | grep 'model name' >>$file
	echo >>$file
	
	echo === >>$file
	echo RAM >>$file
	echo === >>$file
	cat /proc/meminfo | grep MemTotal >>$file
	echo >>$file
	
    interface=$(ip link show | grep 2: | head -n 1 | awk '{print $2}' | sed s/://)
	echo ======= >>$file
	echo Network >>$file
	echo ======= >>$file
	dmesg | grep $interface | grep up >>$file
	echo >>$file
	
	echo ==== >>$file
	echo DISK >>$file
	echo ==== >>$file
	lsblk >>$file
	echo >>$file
	
	echo ============ >>$file
	echo zpool status >>$file
	echo ============ >>$file
	sudo zpool status >>$file
	echo >>$file
	
	echo ======== >>$file
	echo zfs list >>$file
	echo ======== >>$file
	sudo zfs list >>$file
	echo >>$file

	# echo ============= >>$file
	# echo ls -shR /tank >>$file
	# echo ============= >>$file
    # sudo ls -shR /tank >>$file
	# echo >>$file
    
	echo =========== >>$file
	echo Directories >>$file
	echo =========== >>$file
    sudo find /tank -type d >>$file
	echo >>$file
    
	echo ===== >>$file
	echo Files >>$file
	echo ===== >>$file
    sudo find /tank -type f >>$file
	echo >>$file
}

#=================================
help_add 'mkfilelist' '製作檔案清單'
alias mkfilelist='make_filelist'

