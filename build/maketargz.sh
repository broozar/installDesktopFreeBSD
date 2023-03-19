#!/bin/sh

CWD="$(dirname "$0")"
. ${CWD}/../src/include/constants.sh			# global constants
. ${CWD}/../src/include/functions.sh			# general functions

SRC=${CWD}/../src
DST=${CWD}/../release
DTE=$(date '+%Y%m%d')


# ------------------------------------ set build date

echo ${DTE} > ${CWD}/../src/buildversion


# ------------------------------------ welcome message

printf "${CC}FreeBSDesktop Build Script${NC}\n\n"
printf "This script will packe all files ${CY}${SRC}${NC} and create a\n"
printf "self-contained ${CC}TAR${NC}-Archive in ${CY}${DST}${NC}.\n"
printf "${CC}TAR with GZIP${NC} is required.\n\n"

_n "Do you want to continue? [y/N] "
if [ $? -eq 0 ] ; then
	_abort
fi


# ------------------------------------ build

cd ${SRC}
tar -czvf ${DST}/freebsdesktop-${DTE}.tar.gz .
