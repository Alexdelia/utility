# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adelille <adelille@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/30 19:21:49 by adelille          #+#    #+#              #
#    Updated: 2022/09/08 15:43:59 by adelille         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME =	a.out
CC =	clang
RM = 	rm -rf

CFLAGS =	-Wall -Werror -Wextra
#CXXFLAGS +=	-std=c++11

CFLAGS +=	-g3
#CFLAGS +=	-fsanitize=address

#CFLAGS	+=	-pg
#CFLAGS +=	-O2
CFLAGS +=	-fno-builtin

VGLOG =		valgrind.log
NMLOG =		nm.log

VFLAGS =	--leak-check=full --show-leak-kinds=all --track-origins=yes
VFLAGS +=	--track-fds=yes
VFLAGS +=	--verbose
VFLAGS +=	--log-file=$(VGLOG)

LKFLAGS =	-MMD -MP

#NCFLAGS =	-std=c11
#NCFLAGS +=	$(shell ncursesw5-config --cflags --libs)

#NCFLAGS =	-lncurses
#NCFLAGS +=	-D_DEFAULT_SOURCE -D_XOPEN_SOURCE=600 -Wl,-Bsymbolic-functions -lncursesw -ltinfo

# **************************************************************************** #
#	MAKEFILE	#

MAKEFLAGS += --silent

SHELL := bash

B =		$(shell tput bold)
BLA =	$(shell tput setaf 0)
RED =	$(shell tput setaf 1)
GRE =	$(shell tput setaf 2)
YEL =	$(shell tput setaf 3)
BLU =	$(shell tput setaf 4)
MAG =	$(shell tput setaf 5)
CYA =	$(shell tput setaf 6)
WHI =	$(shell tput setaf 7)
D =		$(shell tput sgr0)
BEL =	$(shell tput bel)
CLR =	$(shell tput el 1)

# **************************************************************************** #
#	SRCS	#

SRCSPATH =	./src/
OBJSPATH =	./obj/
INC =		./inc/

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

#SRCS =		$(wildcard $(SRCSPATH)*.cpp) $(wildcard $(SRCSPATH)**/*.cpp)
SRCS =		$(call rwildcard,$(SRCSPATH),*cpp)
SRCSNAME =	$(subst $(SRCSPATH), , $(SRCS))

OBJSNAME =	$(SRCSNAME:.cpp=.o)
OBJS =		$(addprefix $(OBJSPATH), $(OBJSNAME))

# **************************************************************************** #
#	 LIB	#

#LIBPATH =	./libft/
#LIBNAME =	$(LIBPATH)libft.a
#LIBINC =	-I$(LIBPATH)inc/

#ifeq ($(shell uname), Linux)
#MLXPATH =	./mlx/
#else
#	MLXPATH	=	./mlx_macos/
#endif

#MLXNAME =	$(MLXPATH)libmlx.a
#MLXINC =	-I$(MLXPATH)

# *************************************************************************** #

define	progress_bar
	@i=0
	@while [[ $$i -le $(words $(SRCS)) ]] ; do \
		printf " " ; \
		((i = i + 1)) ; \
	done
	@printf "$(B)]\r[$(D)"
endef

define 	call_dependence
	@grep $(2) $(1) && echo 1 > ._x || echo 0 > ._x
	@grep $(3) $(1) && echo 1 > ._y || echo 0 > ._y
	@if [[ $$(cat ._x) -eq 1 && $$(cat ._y) -eq 0 ]] ; then \
		printf "$(B)$(2)$(D) $(B)$(RED)without$(D) $(B)$(3)$(D)\n" ; \
	fi
	@$(RM) ._x ._y
endef

define	nmfind
	@nm -uD $(NAME) > $(NMLOG)
	@printf "\n\t$(D)$(B)$(MAG)nm -uD$(D)\n"
	@cat $(NMLOG)
	@printf "\t$(B)found:$(D)\n"
	@grep printf $(NMLOG) \
		&& printf "$(B)$(YEL)found a printf$(D)\n" \
		|| printf "$(B)$(GRE)no printf$(D)\n"
	@printf "$(B)$(YEL)" && grep mem $(NMLOG) || printf "$(D)"
	@printf "$(B)$(YEL)" && grep exit $(NMLOG) || printf "$(D)"
	$(call call_dependence,$(NMLOG),malloc,free)
	$(call call_dependence,$(NMLOG),new,delete)
	$(call call_dependence,$(NMLOG),open,close)
	$(call call_dependence,$(NMLOG),initscr,endwin)
	@$(RM) $(NMLOG)
	@echo
endef

define fdfind
	@printf "\t$(B)$(MAG)file descriptors$(D)\n"
	@grep "FILE DESCRIPTORS" $(VGLOG)
	@echo
	@grep -A21 "FILE DESCRIPTORS" $(VGLOG) | grep -B2 "by 0x" \
		|| printf "$(B)$(GRE)nothing found$(D)\n"
	@echo
	@[[ $(shell grep "FILE DESCRIPTORS" $(VGLOG) | awk '{print $$4}') -eq 4 ]] \
		|| printf "$(B)$(RED)expected 4 open fds$(D)\n"
endef

# *************************************************************************** #
#	RULES	#

$(OBJSPATH)%.o: $(SRCSPATH)%.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LKFLAGS) -I$(INC) -c $< -o $@
	@printf "$(B)$(GRE)█$(D)"

#ifeq ($(UNAME), Linux)
all:		launch $(NAME)
	@printf "\n$(B)$(MAG)$(NAME) compiled$(D)\n"
#else
#all:
#	@echo "$(B)$(RED)Error: Only Linux supported.$(D)"
#endif

launch:
	$(call progress_bar)

$(NAME):	$(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

test:		all
	valgrind $(VFLAGS) ./$(NAME)
	cat $(VGLOG)
	$(call nmfind)
	$(call fdfind)

#$(LIBNAME):
#	@printf "$(D)$(B)$(BLU)\n$(NAME) objects compiled\n\n$(D)"
#	@$(MAKE) -C $(LIBPATH)

#$(MLXNAME):
#	@$(MAKE) -C $(MLXPATH) > /dev/null 2>&1 || true
#	@printf "\n$(B)$(CYA)$(MLXNAME) compiled\n$(D)"

clean:
	@$(RM) $(OBJSNAME)
#	@$(MAKE) clean -C $(LIBPATH)
#	@$(MAKE) clean -C $(MLXPATH) > /dev/null 2>&1 || true

fclean:		clean
	@$(RM) $(OBJSPATH)
	@$(RM) $(NAME)
#	@$(MAKE) fclean -C $(LIBPATH)

re:			fclean all

-include $(OBJS:.o=.d)

.PHONY: all launch test clean fclean re

# **************************************************************************** #
