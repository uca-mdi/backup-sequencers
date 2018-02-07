#!/usr/bin/env bash

WHO=""  # to change accordingly

SRCRES=/results/analysis/output/Home
SRCPLU=/results/plugins

ENTRYPOINT=/home/ionadmin/NAS   # make sure it's mounted
DST=${ENTRYPOINT}/backup-sequencers/${WHO}
DSTRES=${DST}/results
DSTARC=${DST}/archive
DSTPLU=${DST}/plugins


mountpoint -q ${ENTRYPOINT}

if [[ $? -eq 0 ]]; then
    echo "preparing to backup..."
else
    echo "no mount point found. Aborting"
    exit 1
fi

if [ ! -d $DST ]; then
	mkdir -p $DST
fi

if [ ! -d $DSTARC ]; then
	mkdir $DSTARC
fi

if [ ! -d $DSTRES ]; then
	mkdir $DSTRES
fi

if [ ! -d $DSTPLU ]; then
	mkdir $DSTPLU
fi


echo "Preparing tranfer results => src:'${SRCRES}'; dst:'${DSTRES}'"
# -a does not work due to windows permissions on NAS
# --no-links for avoiding broken links
# --prune-empty-dirs (e.g., "plugins.out/")
rsync -rlDzv --no-links --prune-empty-dirs --dry-run --delete-excluded --delete-during --exclude='*_tn_*' $SRCRES $DSTRES

echo "Preparing tranfer plugins => src:'${SRCPLU}'; dst:'${DSTPLU}'"
. backup_plugins.sh $SRCPLU $DSTPLU