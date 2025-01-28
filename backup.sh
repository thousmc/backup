#!/bin/bash

commands=("advertise" "aws" "date" "echo" "exit" "grep" "mkdir" "ping" "rm" "sleep" "tar" "tmux" "touch")

for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is not installed. Skipping backup."
        exit 1
    else
        echo "$cmd is installed."
    fi
done
echo "All required commands are installed."

if ! ping -c 1 google.com &> /dev/null; then
    echo 'Error: No internet connection detected. Skipping backup.'
    exit 1
fi

date_filename=$(date +%Y-%m-%d-%H-%M-%S-%3N)
start_time=$(date +%s)
backup_directory=$XDG_DATA_HOME/thousmc/backup/backups
backup_file=$backup_directory/thousmc-${date_filename}.tar.gz
backup_name_count_file=$XDG_DATA_HOME/thousmc/backup/backupnamecount.txt
tmux_session=0
thousmc=/home/lcd/thousmc

if advertise -a play.thousmc.xyz -s | grep -q 'True'; then
    ARE_PLAYERS=true
else
    ARE_PLAYERS=false
fi

if ! grep -qE "joined the server|left the server" ~/thousmc/logs/latest.log; then
    echo "No player activity detected today. Backup skipped."
    exit 0
fi

echo "Player activity detected today. Running backup..."
tmux send-keys -t $tmux_session 'save-all' Enter
echo "Saving the game..."
mkdir -p $backup_directory
if [ ! -f $backup_name_count_file ]; then
  touch $backup_name_count_file
fi
saving=true
while $saving; do
    if ! tmux capture-pane -pt 0 -S 10 | grep -q 'Saved the game'; then
        echo 'Waiting for game to save...'
        sleep 5
    else
        echo '"Saved the game" found! Running "save-off" for backup after 5 minute wait...'
        sleep 300  # waiting 5 minutes to account for file write lies
        saving=false
    fi
done

if $ARE_PLAYERS; then tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server is now backing up...","color":"gold"}' Enter; fi
tmux send-keys -t $tmux_session 'save-off' Enter
echo '"save-off" ran...'
rm -v $backup_directory/*
tar czf $backup_file /home/lcd/thousmc
tmux send-keys -t $tmux_session 'save-on' Enter
echo '"save-on" ran...'

end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
filesize=$(stat --format="%s" "$backup_file" | awk '{printf "%.1f", $1 / 1024 / 1024 / 1024}')
hours=$(printf "%02d" $((elapsed_time / 3600)))
minutes=$(printf "%02d" $(((elapsed_time % 3600) / 60)))
seconds=$(printf "%02d" $((elapsed_time % 60)))

if $ARE_PLAYERS; then
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server has been backed up!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session "tellraw @a [\"\",{\"text\":\"Backup took\",\"color\":\"gray\"},{\"text\":\" $hours\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$minutes\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$seconds\",\"color\":\"gold\"},{\"text\":\" with a filesize of\",\"color\":\"gray\"},{\"text\":\" $filesize GiB\",\"color\":\"gold\"},{\"text\":\".\",\"color\":\"gray\"}]" Enter
fi
echo "Creation of \"$backup_file\" took $hours:$minutes:$seconds with a filesize of $filesize GiB."

rsync --checksum -a $backup_file thou@10.0.0.179:/mnt/main/thouset/thou/backups/serverBackups/newBackups/
echo 'Backup copied to NAS server.'
echo thousmc-${date_filename}.tar.gz >> $backup_name_count_file
echo "\"$backup_name_count_file\" updated."

exit 0