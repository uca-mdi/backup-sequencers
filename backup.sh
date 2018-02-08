#!/usr/bin/env bash

WHO=""  # to change accordingly

SRCRES=/results/analysis/output/Home
SRCPLU=/results/plugins

# PATHS
ENTRYPOINT=/home/ionadmin/NAS   # make sure it's mounted
DST=${ENTRYPOINT}/backup-sequencers/${WHO}
DSTRES=${DST}/results
DSTARC=${DST}/archive
DSTPLU=${DST}/plugins

# SET UP
NOW=`date +%Y-%m-%d`

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

# Transfer results
echo "Preparing tranfer results => src:'${SRCRES}'; dst:'${DSTRES}'"
# -a does not work due to windows permissions on NAS
# --no-links for avoiding broken links
# --prune-empty-dirs (e.g., "plugins.out/")
rsync -rlDzv --no-links --prune-empty-dirs --dry-run --delete-excluded --delete-during --exclude='*_tn_*' $SRCRES $DSTRES

# Transfer plugins
echo "Preparing tranfer plugins => src:'${SRCPLU}'; dst:'${DSTPLU}'"
# get the most recent
CURRENT=`ls -tu $DSTPLU | head -1`
if [ "${CURRENT}" != "" ]; then
	echo "first run on plugins"
	mkdir -p $DSTPLU/${NOW}
	DST=$DSTPLU/${NOW}
	rsync -rlDmvz --dry-run $SRCPLU $DST
else
    check=`rsync -ain $SRCPLU $DSTPLU/$CURRENT`
    if [ "${check}" != "" ]; then
	    echo "found modified plugins"
	    mkdir -p $DSTPLU/${NOW}
	    DST=$DSTPLU/${NOW}
	    rsync -rlDzmv --dry-run $SRCPLU $DST
    else
	    echo "no plugins updates"
    fi
fi

# Populate archive
echo "Saving fastq, bam and vcf files on '${DSTARC}'"
rsync -rlDmzv --dry-run --include='*.fastq' --include=".bam" --include="*.vcf" --include='*/' --exclude='*' $DSTRES/ $DSTARC
array=($(find $DSTARC/* -type d -newerat $NOW))

for folder in "${array[@]}"
do
	pushd $folder
	echo "$DSTPLU/$NOW" > plugin_version.info
	popd
done

