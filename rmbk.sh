#!/bin/bash

# rm -r .*~
# rm -r *~
find . -name '.*~' -type f -delete
find . -name '*~' -type f -delete
echo -e "\e[32;1mdone\e[0m"
