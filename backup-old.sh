#!/bin/sh

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

date=$(date +%Y-%m-%d-%H-%M-%S-%3N)
echo "created date: ${date}"

rm -v /home/lcd/bkp/*
tmux send-keys -t 0 'title @a title {"text":"Shutting down now! This will take 30 minutes.","color":"gold"}' Enter
sleep 10
tmux send-keys -t 0 'kick @a Backing up the server... This will take about 30 minutes' Enter
tmux send-keys -t 0 'stop' Enter
tar czvf /home/lcd/bkp/thousmc-${date}.tar.gz /home/lcd/thousmc
tmux send-keys -t 0 'sh /home/lcd/thousmc/start.sh' Enter
rsync --info=progress2 -rv /home/lcd/bkp/thousmc-${date}.tar.gz thou@10.0.0.179:/mnt/main/thouset/thou/backups/serverBackups/newBackups/
