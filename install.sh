#!/bin/sh

dir=$(cd $(dirname $0) | pwd)

echo "STARTING THE INSTALL"

install () {
	echo new dir $1
	for entry in $1
	do
		if [ $entry = "install.sh" ]; then
			continue
		fi
		if [ -d $entry ]; then
			mkdir $HOME/.$entry
			install "$entry/*"
			continue
		fi
		ln -sf $(pwd)/$entry $HOME/.$entry
		echo $(pwd)/$entry
	done
}

install "*" 

echo Configuring your git

git config --global core.excludesfile ~/.gitignore
git config --global core.editor $EDITOR
git config --global core.autocrlf input

echo "Setting up git alias"
git config --global alias.open "! sh -c gopen"
git config --global alias.len "! sh -c \"git ls-files | xargs wc -l\""
git config --global alias.rpush "! sh -c \"git push --set-upstream origin \$(git branch --show-current)\""
git config --global alias.stat "! sh -c gstat"

echo "Enter you email for you git config"
read email
git config --global user.email ${email}

echo "Enter you name for your git config"
read name
git config --global user.name ${name}
