#!/bin/bash

if [[ $# == 2 ]]
then
	len=$1;
	line=$2;
else
	len=1000;
	line=10000;
fi

cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-$len} | head -n $line
