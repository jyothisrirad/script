#/bin/bash

DIR=$(readlink -e $0)
DP0=$(dirname "$DIR")
pname=$(basename "$DP0")
pname_fixed=${pname// /\\ }

echo . "$DP0/config.sh"
. "$DP0/config.sh"

options="--recursive --links --times --verbose --compress --fuzzy --progress --delete-after --delete-excluded --exclude-from ./ignores.txt --backup --backup-dir=/$backup_remote_root/$pname_fixed"

src=.

dst="rsync://$rsync_root/$pname"


pushd "$DP0"

echo rsync $options $src "$dst"
rsync $options $src "$dst"

popd

# sleep 10
