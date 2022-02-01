#!/bin/sh

echo "STARTING THE INSTALL"

for entry in *
do
	if [ $entry = "install.sh" ]; then
		continue
	fi
	ln -sf $(pwd)/$entry $HOME/.$entry
	echo $(pwd)/$entry
done

echo Configuring your git

git config --global core.excludesfile ~/.gitignore
git config --global core.editor $EDITOR
git config --global core.autocrlf input

echo "Enter you email for you git config"
read email
git config --global user.email ${email}

echo "Enter you name for your git config"
read name
git config --global user.name ${name}

echo "Setting up git alias"
git config --global alias.open "! sh -c gopen"
git config --global alias.len "! sh -c \"git ls-files | xargs wc -l\""
