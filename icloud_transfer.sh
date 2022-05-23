#!/bin/bash

mkdir -p "/home/alex/Pictures/Maaike_iCloud/tmp"

echo "unzip"
unzip -o "/home/alex/Pictures/Maaike_iCloud/iCloud Photos.zip" -d "/home/alex/Pictures/Maaike_iCloud/tmp" | pv -l >/dev/null

echo "copy on usb:"
rsync -ah --info=progress2 /home/alex/Pictures/Maaike_iCloud/tmp/* /media/alex/SAVE_MELONS/iCloud\ Photos/

echo "copy on local:"
rsync -ah --info=progress2 /home/alex/Pictures/Maaike_iCloud/tmp/* /home/alex/Pictures/Maaike_iCloud/sorted/

echo ""

(set -x
rm -rf "/home/alex/Pictures/Maaike_iCloud/tmp"
#rm -rf "/home/alex/Pictures/Maaike_iCloud/iCloud Photos.zip"
)

printf "\ndone\n"
