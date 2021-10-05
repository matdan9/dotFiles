#!/usr/bin/env bash

if [ $(uname) = "Darwin" ]; then
	echo seeitng up for macos
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	chsh -s /bin/bash
	brew update
	brew upgrade
	brew install vim mpv tmux docker firefox slack google-chrome cmatrix asciiquarium alacritty postman gnutls htop pandoc
fi
