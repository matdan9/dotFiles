export CLICOLOR=1


# TIRED OF LOOKING UP COLORS
RESET="\[\e[0m\]"
DEF="\[\e[39m\]"
BLACK="\[\e[30m\]"
BRIGHT_BLACK="\[\e[90m\]"
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
BRIGHT_WHITE="\[\e[97m\]"
DARK_GREY="\[\e[90m\]"
LIGHT_RED="\[\e[91m\]"
LIGHT_GREEN="\[\e[92m\]"
LIGHT_YELLOW="\[\e[93m\]"
BOLD="\[\e[1m\]"
DARK=$BRIGHT_BLACK

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
export PATH="/usr/local/bin:${PATH}:~/go/bin"
#/System/Cryptexes/App/usr/bin:/Library/TeX/texbin:/Library/Apple/usr/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Wireshark.app/Contents/MacOS

setDocker() {
	if command -v docker-machine &> /dev/null
	then
		if (docker-machine ls | grep "default.*Running.*") &> /dev/null ; then
			export DOCKER_TLS_VERIFY="1"
			export DOCKER_HOST="tcp://192.168.99.101:2376"
			export DOCKER_CERT_PATH="/Users/mathieu-danielgariepy/.docker/machine/machines/default"
			export DOCKER_MACHINE_NAME="default"
			eval $(docker-machine env) 2&> /dev/null
		fi
	fi
}

(setDocker &)

# ALIASES
alias rob="mpv https://www.twitch.tv/rwxrob"
alias gitlen="git ls-files | xargs wc -l"
alias ls="ls --color -h"
alias vi="vim"
alias less="less -R"
alias grep="grep --color=always -n"
alias nv="nvim"
alias ambient="mpv https://www.youtube.com/watch?v=nRe3xFeyhVY&t=2049s"

# USE VIM KEYBINDS
set -o vi

# MACOS SETUP
if [ "$(uname)" = "Darwin" ]
then
	export BASH_SILENCE_DEPRECATION_WARNING=1
	alias cloud="cd $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs"
	export SHELL="/usr/local/bin/bash"

	[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
	eval "$(/usr/libexec/path_helper)"
fi

