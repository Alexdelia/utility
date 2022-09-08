#!/bin/bash

NAME=${1}
NM='nm -uD'
RM='rm'

NMLOG='nm.log'
VGLOG='vg.log'

VGFLAG='--leak-check=full --show-reachable=yes --track-origins=yes'
VGFLAG+=' --track-fds=yes'
VGFLAG+=' --verbose'
VGFLAG+=' --log-file='${VGLOG}

B='\033[1m'
RED='\033[31m'
GRE='\033[32m'
YEL='\033[33m'
MAG='\033[35m'
CYA='\033[36m'
D='\033[0m'

[ $# -lt 1 ] && echo -e "usage: ${CYA}$0${D} ${MAG}<file>${D}" && exit 1

[ ! -f $1 ] && echo -e "${B}${RED}[ERROR]:${D}${RED} file ${B}${MAG}$1${D}${RED} does not ${YEL}exist${D}" && exit 1
[ ! -x $1 ] && echo -e "${B}${RED}[ERROR]:${D}${RED} file ${B}${MAG}$1${D}${RED} is not ${YEL}executable${D}" && exit 1
[ ! -s $1 ] && echo -e "${B}${RED}[ERROR]:${D}${RED} file ${B}${MAG}$1${D}${RED} is ${YEL}empty${D}" && exit 1


call_dependence ()
{
    grep ${2} ${1}
    _x=$?
    grep ${3} ${1}
    _y=$?
    [ ${_x} -eq 0 ] && [ ${_y} -eq 1 ] && echo -e "${B}${2}${D} ${B}${RED}without${D} ${B}${3}${D}\n"
    [ ${_x} -eq 1 ] && [ ${_y} -eq 0 ] && echo -e "${B}${3}${D} ${B}${RED}without${D} ${B}${2} ${RED}???${D}\n"
    [ ${_x} -eq 0 ] && [ ${_y} -eq 0 ] && echo
}

nmfind ()
{
    ${NM} ${NAME} > ${NMLOG}
    printf "\n\t${D}${B}${MAG}${NM}${D}\n"
    cat ${NMLOG}
    printf "\n\t${B}found:${D}\n\n"
    grep printf ${NMLOG} \
    && printf "${B}${YEL}found a printf${D}\n\n" \
    || printf "${B}${GRE}no printf${D}\n\n"
    printf "${B}${YEL}" && grep mem ${NMLOG} || printf "${D}\n"
    printf "${B}${YEL}" && grep exit ${NMLOG} || printf "${D}\n"
    call_dependence "${NMLOG}" "malloc" "free"
    call_dependence "${NMLOG}" "new" "delete"
    call_dependence "${NMLOG}" "open" "close"
    call_dependence "${NMLOG}" "initscr" "endwin"
    ${RM} ${NMLOG}
}

fdfind ()
{
    printf "\t${B}${MAG}file descriptors${D}\n"
    grep "FILE DESCRIPTORS" ${VGLOG}
    echo
    grep -A21 "FILE DESCRIPTORS" ${VGLOG} | grep -B2 "by 0x" \
    || printf "${B}${GRE}nothing found${D}\n"
    echo
    [[ $(grep "FILE DESCRIPTORS" ${VGLOG} | awk '{print $4}') -eq 4 ]] \
    || printf "${B}${RED}expected 4 open fds at exit${D}\n"
}

vginit ()
{
    valgrind ${VGFLAG} ${NAME}
    printf "\t${D}${B}${MAG}valgrind${D}\n"
    cat ${VGLOG}
}

vginit
nmfind
fdfind
