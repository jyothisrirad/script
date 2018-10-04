#!/bin/bash

#=================================
# help_hline3 'speedtest'

#=================================
make_filelist() {
    [ ! -d /tank ] && echo /tank does not exist && return
    ls -shR /tank >~/$(hostname).filelist.txt
}

#=================================
help_add 'mkfilelist' '製作檔案清單'
alias mkfilelist='make_filelist'

