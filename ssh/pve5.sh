fullfile=$0
filename=$(basename "$fullfile")
extension="${filename##*.}"
#filename="${filename%.*}"
host="${filename%.*}"

#ssh -i ~/Dropbox/SSHKey/nb19_rsa sita@$host
ssh -i /mnt/d/Users/sita/Dropbox/SSHKey/nb19_rsa sita@$host
