export CLICOLOR=1

# Tired of looking up colors
export RESET="\e[0m"
export DEF="\e[39m"
export BLACK="\e[30m"
export RED="\e[31m"
export GREEN="\e[32m"
export YELLOW="\e[33m"
export BLUE="\e[34m"
export MAGENTA="\e[35m"
export CYAN="\e[36m"
export LIGTH="\e[37m"
export DARK_GREY="\e[90m"
export LIGHT_RED="\e[91m"
export LIGTH_GREEN="\e[92m"
export LIGTH_YELLOW="\e[93m"
export BOLD="\e[1m"

export DARK=$DARK_GREY

if [ $(tput colors) = "256" ]; then
	export DARK="\e[38;5;240m"
fi

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

export lamp="10.10.4.36 - LAMP (PHP 7.4)"
export TERM=xterm-256color
export VISUAL="vim"

alias rob="mpv https://www.twitch.tv/rwxrob"
alias cloud="cd $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs"

if [ "$(uname)" = "Darwin" ]
then
	export BASH_SILENCE_DEPRECATION_WARNING=1
fi

set -o vi
