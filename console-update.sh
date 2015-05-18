#exit if not under tmux
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  echo Please run under tmux. 
  echo Exiting now...
  exit 
fi

~/script/update.sh
