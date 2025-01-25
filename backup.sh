#!/bin/bash

BACKUP_DIRECTORY=$XDG_DATA_HOME/thousmc/backup
ADVERTISE_DIR=$HOME/docs/software/code/python/advertise/advertise.py  # ill have to change this for each implementation

if ! grep -qE "joined the server|left the server" ~/thousmc/logs/latest.log; then
    echo "No player activity detected. Backup skipped."
else
    echo "Player activity detected. Running backup..."
    if $(python3 $ADVERTISE_DIR -a -s ) == 'True'; then
        echo 'True!'
    else
        echo 'False!'
    fi
fi
