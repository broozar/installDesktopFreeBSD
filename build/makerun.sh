#!/bin/sh

# BUG WARNING #######################################
# This script creates files the APPEAR to work, but
# the installations will FAIL to launch the desktops.
# If you can find the error, please let me know.
# For now. please use TAR or TARGZ instead.
# BUG WARNING #######################################


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
printf "self-contained ${CC}RUN${NC}-Archive in ${CY}${DST}${NC}.\n"
printf "${CC}MAKESELF${NC} is required.\n\n"

_n "Do you want to continue? [y/N] "
if [ $? -eq 0 ] ; then
	_abort
fi


# ------------------------------------ build

cd ${DST}
makeself --notemp ${SRC} freebsdesktop-${DTE}.run "Unpacking FreeBSDesktop installer ${DTE}..." ./main.sh
