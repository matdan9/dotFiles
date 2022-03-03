export CLICOLOR=1

# TIRED OF LOOKING UP COLORS
RESET="\[\e[0m\]"
DEF="\[\e[39m\]"
BLACK="\[\e[30m\]"
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
LIGTH="\[\e[37m\]"
DARK_GREY="\[\e[90m\]"
LIGHT_RED="\[\e[91m\]"
LIGTH_GREEN="\[\e[92m\]"
LIGTH_YELLOW="\[\e[93m\]"
BOLD="\[\e[1m\]"
DARK=$DARK_GREY

# CUSTOM PROMPT
__ps1() {
	local E="$?"
	export PS1=""
	if [ "$E" = "0" ]; then
		PS1+="${GREEN}√${DARK} "
	else
		PS1+="${RED}?${E}${DARK} "
	fi
	branch="$(git branch --show-current 2> /dev/null)"
	if [ "$branch" != "" ]; then
		PS1+="(${YELLOW} ${branch}${DARK}) "
	fi
	PS1+="${BOLD}${DARK}${PWD#"${PWD%/*/*}/"} "

	PS1+="${RESET}\$ -> "
}
PROMPT_COMMAND="__ps1"

# ENV VARIABLE
export TERM=xterm-256color
export VISUAL="vim"
export EDITOR="vim"
export TERMINAL="alacritty"

# ALIASES
alias rob="mpv https://www.twitch.tv/rwxrob"
alias gitlen="git ls-files | xargs wc -l"
alias ls="ls --color -h"
alias vi="vim"
alias less="less -R"

# REMOVE MACOS WARNING FOR BASH
if [ "$(uname)" = "Darwin" ]
then
	export BASH_SILENCE_DEPRECATION_WARNING=1
	alias cloud="cd $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs"
fi

# USE VIM KEYBINDS
set -o vi
