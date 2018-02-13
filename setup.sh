#!/bin/bash

SCRIPT='./backup.sh'
NAME=

if [ -z "$1" ]; then
    echo -e "Usage: '$0 <name of server>'\n"
    exit 1
else
    NAME=$1
fi

if [ ! -f ${SCRIPT} ]; then
	echo 'file ${SCRIPT} not found. Aborting'
	exit 1
else
	sed -i 's/--dry-run//g' ${SCRIPT}
	sed -i 's/^WHO=\"\"/WHO=\"'$NAME'\"/g' ${SCRIPT}
	echo 'done'
fi
