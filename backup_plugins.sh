#!/bin/bash

NOW=`date +%Y-%m-%d`

SRCPLU=$1
DSTPLU=$2

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
