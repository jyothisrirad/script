#/bin/bash

for szFile in /proc/*/status ; do 

  awk '/VmSwap|Name/{printf $2 "\t" $3}END{ print "" }' $szFile 

done | sort --key 2 --numeric --reverse | more
