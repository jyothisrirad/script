fullfile=$0
filename=$(basename "$fullfile")
extension="${filename##*.}"
#filename="${filename%.*}"
host="${filename%.*}"

#ssh sita@$host
ssh sita@192.168.1.211
