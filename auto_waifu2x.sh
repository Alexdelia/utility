#!/bin/bash

printf "\033[1;36mStarting\033[0m\n\n"
#shopt -s extglob
files=$(find . -type f -not -name '*_w2.png' -and -not -name '*_w2x.png' -and -not -name '*.ini')
for f in $files ; do
	echo "Doing:" "$f"
	/home/alex/Ware/waifu2x-ncnn-vulkan-20210521-ubuntu/waifu2x-ncnn-vulkan -i "$f" -o "${f%.*}"_w2.png -n 2 -s 2
	file "${f%.*}"_w2.png | awk '{print $1,"\033[1;31m",$5,$6,$7,"\033[0m\n"}' | tr ',' ' '
	cp "$f" /home/alex/Pictures/.backup_wallpaper/
	rm "$f"
done
printf "\033[1;32mDone\033[0m\n"
