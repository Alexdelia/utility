#!/bin/bash

if [[ $# < 1 ]]
then
	echo "need name of file"
	exit 0
fi

commit=""

for file in "$@"
do
	git add "$file"
	commit+="\`$file\` "
done

git commit -m "$commit"
git push
