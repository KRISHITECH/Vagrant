#!/bin/bash
exit 1


tmux new-session -d -s farmbot 'bash web_api_startup.sh'
tmux rename-window 'Farmbot'
tmux select-window -t farmbot:0
tmux split-window -h 'bash mqtt_startup.sh'
tmux split-window -v -t 0 'bash frontend_startup.sh'
tmux -2 attach-session -t farmbot
