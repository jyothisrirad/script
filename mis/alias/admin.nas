#!/bin/bash

#=================================
# help_hline3 'speedtest'

#=================================
make_filelist() {
    [ ! -d /tank ] && echo /tank does not exist && return
	file=~/$(hostname).filelist.txt
	[ -f $file ] && rm $file
	sudo zpool status >>$file
	sudo zfs list >>$file
    sudo ls -shR /tank >>$file
}

#=================================
help_add 'mkfilelist' '製作檔案清單'
alias mkfilelist='make_filelist'

