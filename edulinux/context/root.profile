# ~/.profile: executed by Bourne-compatible login shells.

export PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
