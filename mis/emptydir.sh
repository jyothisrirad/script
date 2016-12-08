dirs=( $(find ~/ -type d -empty) )

empty=${dirs[0]}

empty=${($(find ~/ -type d -empty))[0]}

echo $empty
