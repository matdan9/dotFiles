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
if [ -z ${MATDAN_ENV_IS_SETUP} ]; then
	echo "Setting up PATH, XDG_DATA_HOME"
	export MATDAN_ENV_IS_SETUP="TRUE"
	export PATH="/usr/local/bin:${PATH}:${HOME}/go/bin:${HOME}/.local/bin:${HOME}/.cargo/bin"
fi
export TERM=xterm-256color
export VISUAL="nvim"
export EDITOR="nvim"
export TERMINAL="alacritty"
export CMAKE_EXPORT_COMPILE_COMMANDS=1 # makes sure cmake always exports compile commands for clangd
export CMAKE_COLOR_DIAGNOSTICS="ON" # enables colored diagnostics in cmake

# ALIASES
alias gitlen="git ls-files | xargs wc -l"
alias ls="ls --color -h"
alias vi="vim"
alias less="less -R"
alias grep="grep --color=always -n"
alias nv="nvim"

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

# Load Angular CLI autocompletion.
if command -v ng &> /dev/null
then
	source <(ng completion script)
fi
