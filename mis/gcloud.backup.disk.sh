#!/bin/bash

. /home/sita/script/include/console.color

SOURCEDISK="/dev/sda"
RAWDISK="/tmp/disk.raw"
GZDISK="/tmp/compressed-image.tar.gz"

echo -e ${GREEN}Dumping $SOURCEDISK to $RAWDISK ... ${NC}
sudo dd if=$SOURCEDISK of=$RAWDISK bs=4M conv=sparse

echo -e ${GREEN}Comressing $RAWDISK to $GZDISK ... ${NC}
sudo tar -Sczf $GZDISK $RAWDISK
