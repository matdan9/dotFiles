#!/bin/sh

dir=$(cd $(dirname $0) | pwd)

echo "STARTING THE INSTALL"

install () {
	for entry in $1
	do
		if [ $entry = "install.sh" ]; then
			continue
		fi
		if [ -d $entry ]; then
			install "$entry/*"
			continue
		fi
		if [ $(dirname $entry) = "." ]; then
			echo "HOME DIR"
		else
			mkdir -p "${HOME}/.$(dirname $entry)"
			echo "new dir ${HOME}/.$(dirname $entry)"
		fi
		echo "ln -sf $(pwd)/$entry ${HOME}/.$entry"
		ln -sf "$(pwd)/$entry" "${HOME}/.$entry"
	done
}

echo Getting vim themes

for t in $(cat ${dir}/vimThemeSources); do
	curl -L "${t}" --output-dir ./vim/colors/ --remote-name
done

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
git config --global core.ignorecase false

echo "Enter you email for you git config"
read email
git config --global user.email ${email}

echo "Enter you name for your git config"
read name
git config --global user.name ${name}

# NVIM SUTFF BECAUSE I HAVE TO TRY IT ATLEAST ONCE EVEN IF I DON'T LIKE IT'S APPROCHE
# installer packer (package manager)
git clone --depth 1 https://github.com/wbthomason/packer.nvim\ ~/.local/share/nvim/site/pack/packer/start/packer.nvim
