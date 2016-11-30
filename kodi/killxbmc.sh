kill -9 $(ps aux | grep '[x]bmc' | awk '{print $2}')
