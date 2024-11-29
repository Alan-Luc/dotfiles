# Use powerline
# USE_POWERLINE="true"
# # Source manjaro-zsh-configuration
# if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
#   source /usr/share/zsh/manjaro-zsh-config
# fi
# # Use manjaro zsh prompt
# if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#   source /usr/share/zsh/manjaro-zsh-prompt
# fi
export PATH="$HOME/.local/bin/:$PATH"

# plugins
plugins=(
  archlinux
	git-prompt
  command-not-found
  git
  sudo
)

ZSH_THEME=dallas

ZSH=/usr/share/oh-my-zsh/
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

# prompt
PROMPT='%~ %F{red}$%f '

# aliases
source ~/.aliases
# setopt COMPLETE_ALIASES

# index PATH on tab completion
zstyle ':completion:*' rehash true

# ctrl-shift-arrow word movement
bindkey -e
bindkey '^[[c' forward-word
bindkey '^[[d' backward-word

# search arch repos for commands
source /usr/share/doc/pkgfile/command-not-found.zsh

export EDITOR=vim

# golang
export GOROOT=/usr/lib/go
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

# python

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
# vim: sw=4


# osu trainer
export OSU_SONG_FOLDER=/home/alan/.local/share/osu-wine/osu!/Songs

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# pnpm
export PNPM_HOME="/home/alan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
