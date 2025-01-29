#!/bin/bash

# this is really stupid but & ugly but it works

tmux_session=0

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 30 minutes!","color":"gold"}' Enter
fi

sleep 600

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 20 minutes!","color":"gold"}' Enter
fi

sleep 600

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 10 minutes!","color":"gold"}' Enter
fi

sleep 300

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 5 minutes!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 5 minutes!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
fi

sleep 240

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 1 minute!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 1 minute!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
fi

sleep 50

if $(advertise -a play.thousmc.xyz -s | grep -q 'True'); then
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 10 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 10 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 9 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 9 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 8 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 8 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 7 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 7 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 6 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 6 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 5 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 5 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 4 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 4 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 3 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 3 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 2 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 2 seconds...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server will restart in 1 second...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server will restart in 1 second...","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 1
    tmux send-keys -t $tmux_session 'tellraw @a {"text":"Server restarting now!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'title @a title {"text":"Server restarting now!","color":"gold"}' Enter
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session 'playsound block.note_block.harp master @a ~ ~ ~ 1 2 1' Enter
    sleep 0.1
    tmux send-keys -t $tmux_session '§6Server is restarting. Please rejoin in 1 minute.' Enter
fi

tmux send-keys -t $tmux_session 'stop' Enter
on=true
while $on; do
    if ! tmux capture-pane -pt $tmux_session -S 10 | grep -q 'Server stopped!'; then
        sleep 0.5
    else
        on=false
    fi
done

tmux send-keys -t $tmux_session 'sh /home/lcd/thousmc/start.sh' Enter