#!/bin/bash

clang -Wall -Werror -Wextra -g -fsanitize=address *.c
