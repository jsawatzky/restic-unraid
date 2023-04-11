#!/bin/bash

if [ ! -z $DRYRUN ]; then
    DRYRUN_ARG="-n"
fi

backup() {
    if [ ! -f $1/.restic-exclude ]; then
        touch $1/.restic-exclude
    fi

    echo "$(date +%y-%m-%dT%H:%M:%S) [INFO] Backing up $1..."
    if restic backup $DRYRUN_ARG -H $HOSTNAME --exclude-caches --one-file-system --exclude-file $1/.restic-exclude $1; then
        echo "$(date +%y-%m-%dT%H:%M:%S) [INFO] Successfully backed up $1"
    else
        echo "$(date +%y-%m-%dT%H:%M:%S) [ERROR] Failed to backup $1"
    fi
}

DIRS="/mnt/*"
for d in $DIRS; do
    backup $d
done
