# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	# [ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE" 
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi



# Load local bash/zsh compatible settings
INIT_SH_NOFUN=1
INIT_SH_NOLOG=1
DISABLE_Z_PLUGIN=1
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"

# exit for non-interactive shell
[[ $- != *i* ]] && return

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
# https://github.com/microsoft/WSL/issues/1887#issuecomment-299515428
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE

# Initialize command prompt
# export PS1="%n@%m:%~%# "

# Initialize antigen
source "$ANTIGEN"

# Setup dir stack
DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups cdablevars
alias d='dirs -v | head -10'

# Disable correction https://stackoverflow.com/questions/14162322/zsh-overzealously-trying-to-correct-feature-to-features
# unsetopt correct_all
# unsetopt correct
# DISABLE_CORRECTION="true" 

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

ZSH_AUTOSUGGEST_USE_ASYNC=1

# Declare modules
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:git:alias' skip 'yes'
zstyle ':prezto:module:prompt' theme 'sorin'
zstyle ':prezto:module:prompt' pwd-length 'short'
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:autosuggestions' color 'yes'
zstyle ':prezto:module:python' autovenv 'yes'
zstyle ':prezto:load' pmodule \
	'environment' \
	'editor' \
	'history' \
	'git' \
	'utility' \
	'completion' \
	'history-substring-search' \
	'autosuggestions' \
	'prompt'
# environment: Sets general shell options and defines environment variables.
# editor: vi/emacs mode for commandline
# git: funtions, alias, prompt info
# history: preset history options and alias history-stat
# utility: general aliases and functions. ll la etc.
# completion: Loads and configures tab completion and provides additional completions from the zsh-completions project.
# history-substring-search: user can type in any part of a previously entered command and press up and down to cycle through matching commands
# autosuggestions: user can type in any part of a previously entered command and Zsh suggests commands as you type based on history and completions.

# Initialize prezto
antigen use prezto


# default bundles
antigen bundle rupa/z z.sh  # z foo bar to most frecency dir /foo/bar
antigen bundle Vifon/deer # file navigator gui
antigen bundle zdharma/fast-syntax-highlighting  # syntax highliting for zsh

antigen bundle willghatch/zsh-cdr
# antigen bundle zsh-users/zaw

# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

antigen apply

# work around: fast syntax highlighting may crash zsh without this
# FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"

# setup for deer
autoload -U deer
zle -N deer

# default keymap


# source function.sh if it exists
[ -f "$HOME/.local/etc/function.sh" ] && . "$HOME/.local/etc/function.sh"

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

PATH=$PATH:/Users/hzzoujunyang/Library/Python/2.7/bin

