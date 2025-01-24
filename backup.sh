#!/bin/bash

BACKUP_DIRECTORY = $XDG_DATA_HOME/thousmc/backup

if ! grep -qE "joined the server|left the server" ~/thousmc/logs/latest.log; then
    echo "No player activity detected. Backup skipped."
else
    echo "Player activity detected. Running backup..."
    mkdir -p $BACKUP_DIRECTORY

fi
