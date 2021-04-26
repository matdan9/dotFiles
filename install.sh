#!/bin/sh

for entry in "."/*
do
	if [ $entry = "./install.sh" ]; then
		continue
	fi
	ln -sf $(pwd)/$entry $HOME
	echo $(pwd)/$entry
done

