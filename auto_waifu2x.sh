# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto_waifu2x.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adelille <adelille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/18 05:46:50 by adelille          #+#    #+#              #
#    Updated: 2021/10/09 18:58:12 by adelille         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

echo "Starting"
shopt -s extglob
files=$(find . -type f -not -name '*_w2.png' -and -not -name '*.ini')
for f in $files ; do
	echo "Doing:" $f
	w2x -i "$f" -o "${f%.*}"_w2.png -n 2 -s 2
	cp "$f" /home/alex/Pictures/.backup_wallpaper/
	rm "$f"
done
