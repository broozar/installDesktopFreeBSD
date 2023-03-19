#!/bin/sh
# figure out latest PMA version and install

CWD="$(dirname "$0")"
. ${CWD}/../src/include/constants.sh			# global constants
. ${CWD}/../src/include/kbd_str.sh				# keyboard constants
. ${CWD}/../src/include/variables.sh			# control variables
. ${CWD}/../src/include/functions.sh			# general functions
. ${CWD}/../src/include/functions_dia.sh		# dialog functions

_pi apache24
_pil mariadb ^mariadb[0-9]*-server
_pil mariadb ^mariadb[0-9]*-client
_pil phpmyadmin5 ^phpMyAdmin5-php[0-9]