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

