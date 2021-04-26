export LSCOLORS=GxFxCxDxBxegedabagaced

autoload -U colors && colors
PS1="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[cyan]%}%1~%{$reset_color%} %% "

export CLICOLOR=1
setopt PROMPT_SUBST
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%2~%f%b %# -> '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git


export lamp="10.10.4.36 - LAMP (PHP 7.4)"
export TERM=xterm-256color

alias rob="mpv https://www.twitch.tv/rwxrob"
alias cloud="cd $HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs"
alias soundFix="sudo kill -15 $(pgrep coreaudio)"
