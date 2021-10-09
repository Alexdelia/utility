# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto_waifu2x.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adelille <adelille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/18 05:46:50 by adelille          #+#    #+#              #
#    Updated: 2021/10/09 19:24:33 by adelille         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

echo "Starting"
#shopt -s extglob
files=$(find . -type f -not -name '*_w2.png' -and -not -name '*_w2x.png' -and -not -name '*.ini')
for f in $files ; do
	echo "Doing:" $f
	 /var/lib/flatpak/app/com.github.nihui.waifu2x-ncnn-vulkan/current/8bf9ef4885a0ca7426344fd1a080f8290c42373bb3e7aa5327a189c9319b4a27/export/bin/com.github.nihui.waifu2x-ncnn-vulkan -i "$f" -o "${f%.*}"_w2.png -n 2 -s 2
	cp "$f" /home/alex/Pictures/.backup_wallpaper/
	rm "$f"
done
echo "Done"
