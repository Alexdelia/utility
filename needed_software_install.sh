#!/bin/bash

if [[ $EUID != 0 ]]
then
	printf "\033[31;1mError:\t\033[0m\033[31mneed sudo\033[0m\n"
	exit 1
fi

sudo apt update
sudo apt install git vim kitty steam plank shutter
