if [ -z ${1+x} ] && [ $1 -eq notest ]; then 
  echo notest
else
if type tmux >/dev/null 2>/dev/null; then
  # you can start tmux if you want
  if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; then
    echo Already running tmux.
  else
    echo Running tmux ...
    tmux -c $0 notest 
  fi
else
  echo Please install tmux.
fi
fi
