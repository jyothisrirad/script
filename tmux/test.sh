#!/bin/bash

session="$0"
logs_dir=~/session-logs

mkdir -p "$logs_dir"

# Start session if it doesn't exist
if (tmux has-session -t "$session" 2> /dev/null); then
	echo "Session $session exists."
else
	echo "Starting session $session."
	# tmux doesn't allow nested sessions, and if this situation is not caught here then the
	# 'tmux new-session' command will fail.  Although, since the session is being started
	# detached, it is probably okay.  So maybe it would be better to just temporarily unset the
	# TMUX variable before running new-session.
	if [ "$TMUX" != "" ]; then
		echo "Error: cannot start session from within tmux."
		exit
	fi
	tmux new-session -d -s "$session" "sh $0"
	tmux attach
fi
