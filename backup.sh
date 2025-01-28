#!/bin/bash

DATE_FILENAME=$(date +%Y-%m-%d-%H-%M-%S-%3N)
START_TIME=$(date +%s)
BACKUP_DIRECTORY=$XDG_DATA_HOME/thousmc/backup
BACKUP_FILE=$BACKUP_DIRECTORY/thousmc-${DATE_FILENAME}.tar.gz
ADVERTISE_DIR=$HOME/docs/software/code/python/advertise/advertise.py  # ill have to change this for each implementation
TMUX_SESSION=0

if python3 $ADVERTISE_DIR -a play.thousmc.xyz -s | grep -q 'True'; then
    ARE_PLAYERS=true
else
    ARE_PLAYERS=false
fi

if ! grep -qE "joined the server|left the server" ~/thousmc/logs/latest.log; then
    echo "No player activity detected today. Backup skipped."
    exit 1
fi

echo "Player activity detected today. Running backup..."
tmux send-keys -t $TMUX_SESSION 'save-all' Enter
echo "Saving the game..."
mkdir -p $BACKUP_DIRECTORY
saving=true
while $saving; do
    if ! tmux capture-pane -pt 0 -S 10 | grep -q 'Saved the game'; then
        echo 'Waiting for game to save...'
        sleep 5
    else
        echo '"Saved the game" found! Running "save-off" for backup...'
        saving=false
    fi
done

if $ARE_PLAYERS; then tmux send-keys -t $TMUX_SESSION 'tellraw @a {"text":"Server is now backing up...","color":"gold"}' Enter; fi
tmux send-keys -t $TMUX_SESSION 'save-off' Enter
echo '"save-off" ran...'
rm -v $BACKUP_DIRECTORY/*
tar czf $BACKUP_FILE /home/lcd/thousmc
tmux send-keys -t $TMUX_SESSION 'save-on' Enter
echo '"save-on" ran...'

end_time=$(date +%s)
elapsed_time=$(($end_time - $START_TIME))
filesize=$(stat --format="%s" "$BACKUP_FILE" | awk '{printf "%.1f\n", $1 / 1024}')
hours=$(($elapsed_time / 3600))
minutes=$((($elapsed_time % 3600) / 60))
seconds=$(($elapsed_time % 60))

if $ARE_PLAYERS; then
    tmux send-keys -t $TMUX_SESSION 'tellraw @a {"text":"Server has been backed up!","color":"gold"}' Enter
    tmux send-keys -t $TMUX_SESSION "tellraw @a [\"\",{\"text\":\"Backup took\",\"color\":\"gray\"},{\"text\":\" $hours\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$minutes\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$seconds\",\"color\":\"gold\"},{\"text\":\" with a filesize of\",\"color\":\"gray\"},{\"text\":\" $filesize GiB\",\"color\":\"gold\"},{\"text\":\".\",\"color\":\"gray\"}]" Enter
fi
echo "Creation of \"$BACKUP_FILE\" took $hours:$minutes:$seconds with a filesize of $filesize\GiB."

rsync --checksum -a $BACKUP_FILE thou@10.0.0.179:/mnt/main/thouset/thou/backups/serverBackups/newBackups/
echo 'Backup copied to NAS server.'