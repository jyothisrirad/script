#!/bin/bash

#=================================
# help_hline3 'speedtest'

#=================================
make_filelist() {
    tank="mnt"
    [ -d /tank ] && tank="tank"
    [ ! -d /$tank ] && echo /$tank does not exist && return
	
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
	
    interface=$(ip link show | grep BROADCAST | head -n 1 | awk '{print $2}' | sed s/:// | tr "@" "\n" | head -n 1)
	echo ======= >>$file
	echo Network >>$file
	echo ======= >>$file
	dmesg | grep -i duplex >>$file
	[ $(sudo which ethtool) ] && sudo ethtool $interface | grep Speed >>$file
	[ $(sudo which mii-tool) ] && sudo mii-tool -v $interface >>$file
	echo >>$file
	
	echo ==== >>$file
	echo DISK >>$file
	echo ==== >>$file
	lsblk >>$file
	echo >>$file
	
	[ $(sudo which zpool) ] && echo ============ >>$file
	[ $(sudo which zpool) ] && echo zpool status >>$file
	[ $(sudo which zpool) ] && echo ============ >>$file
	[ $(sudo which zpool) ] && sudo zpool status >>$file
	[ $(sudo which zpool) ] && echo >>$file
	
	[ $(sudo which zfs) ] && echo ======== >>$file
	[ $(sudo which zfs) ] && echo zfs list >>$file
	[ $(sudo which zfs) ] && echo ======== >>$file
	[ $(sudo which zfs) ] && sudo zfs list >>$file
	[ $(sudo which zfs) ] && echo >>$file

	# echo ============= >>$file
	# echo ls -shR /$tank >>$file
	# echo ============= >>$file
    # sudo ls -shR /$tank >>$file
	# echo >>$file
    
	echo =========== >>$file
	echo Directories >>$file
	echo =========== >>$file
    sudo find /$tank -type d >>$file
	echo >>$file
    
	echo ===== >>$file
	echo Files >>$file
	echo ===== >>$file
    sudo find /$tank -type f >>$file
	echo >>$file
}

#=================================
help_add 'mkfilelist' '製作檔案清單'
alias mkfilelist='make_filelist'

