#!/bin/bash

commands=("advertise" "aws" "basename" "cat" "date" "echo" "exit" "grep" "mkdir" "pigz" "ping" "rm" "sleep" "tar" "tmux" "touch")

for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: \"$cmd\" is not installed. Backup skipped."
        exit 1
    else
        echo "\"$cmd\" is installed."
    fi
done
echo "All required commands are installed."

if ! ping -c 1 google.com &> /dev/null; then
    echo "Error: No internet connection detected. Backup skipped."
    exit 1
fi

# i added these as a test to see if it makes cron read the XDG environment variables correctly. will be removed if not
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

date_filename=$(date +%Y-%m-%d-%H-%M-%S-%3N)
start_time=$(date +%s)
backup_directory=$XDG_DATA_HOME/thousmc/backup/backups
backup_file=$backup_directory/thousmc-${date_filename}.tar.gz
backup_file_basename=$(basename $backup_file)
backup_name_count_file=$XDG_STATE_HOME/thousmc/backup/backupnamecount.txt
tmux_session=0
s3_bucket=$(cat $XDG_CONFIG_HOME/thousmcbackupsbucketname.txt)
thousmc="$HOME/thousmc"

if advertise -a play.thousmc.xyz -s | grep -q 'True'; then
    are_players=true
else
    are_players=false
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
  mkdir -p $XDG_STATE_HOME/thousmc/backup
  touch $backup_name_count_file
fi
saving=true
while $saving; do
    if ! tmux capture-pane -pt $tmux_session -S 10 | grep -q 'Saved the game'; then
        echo "Waiting for game to save..."
        sleep 5
    else
        echo "\"Saved the game\" found!"
        echo "Running \"save-off\" for backup after 1 minute wait..."
        sleep 60  # waiting 1 minute to account for file write lies
        saving=false
    fi
done

if $are_players; then tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server is now backing up...","color":"gold"}' Enter; fi
tmux send-keys -t $tmux_session 'save-off' Enter
echo "\"save-off\" ran..."
rm -v $backup_directory/*
tar -cf - $thousmc | pigz > $backup_file
tmux send-keys -t $tmux_session 'save-on' Enter
echo "\"save-on\" ran..."

end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
hours=$(printf "%02d" $((elapsed_time / 3600)))
minutes=$(printf "%02d" $(((elapsed_time % 3600) / 60)))
seconds=$(printf "%02d" $((elapsed_time % 60)))
filesize=$(stat --format="%s" "$backup_file" | awk '{printf "%.1f", $1 / 1024 / 1024 / 1024}')

if $are_players; then
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server has been backed up!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session "tellraw @a [\"\",{\"text\":\"Backup took\",\"color\":\"gray\"},{\"text\":\" $hours\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$minutes\",\"color\":\"gold\"},{\"text\":\":\",\"color\":\"gray\"},{\"text\":\"$seconds\",\"color\":\"gold\"},{\"text\":\" with a filesize of\",\"color\":\"gray\"},{\"text\":\" $filesize GiB\",\"color\":\"gold\"},{\"text\":\".\",\"color\":\"gray\"}]" Enter
fi
echo "Creation of \"$backup_file_basename\" took $hours:$minutes:$seconds with a filesize of $filesize GiB."

echo "Copying \"$backup_file_basename\" to NAS server..."
rsync --checksum -a $backup_file thou@10.0.0.179:/mnt/main/thouset/thou/backups/serverBackups/newBackups/
echo "\"$backup_file_basename\" copied to NAS server."
echo thousmc-${date_filename}.tar.gz >> $backup_name_count_file
echo "\"$backup_name_count_file\" updated."

./restart30.sh &

if ! aws s3api head-bucket --bucket $s3_bucket &> /dev/null; then
    echo "Error: No access to S3 bucket \"$s3_bucket\"."
    exit 1
fi

if (( $(wc -l $backup_name_count_file | awk '{print $1}') % 7 == 0)); then
    echo "This is backup #$(wc -l $backup_name_count_file | awk '{print $1}'). Copying \"$backup_file_basename\" to AWS S3..."
    aws s3 cp $backup_file s3://$s3_bucket --storage-class DEEP_ARCHIVE
    echo "\"$backup_file_basename\" copied to AWS S3."
else
    echo "This is backup #$(wc -l $backup_name_count_file | awk '{print $1}'), which isn't divisible by 7. AWS S3 backup skipped."
fi

exit 0