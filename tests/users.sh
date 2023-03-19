#!/bin/sh
# create user with dia

CWD="$(dirname "$0")"
. ${CWD}/../src/include/constants.sh			# global constants
. ${CWD}/../src/include/kbd_str.sh				# keyboard constants
. ${CWD}/../src/include/variables.sh			# control variables
. ${CWD}/../src/include/functions.sh			# general functions
. ${CWD}/../src/include/functions_dia.sh		# dialog functions

_dn "Do you want to add new users to the system (strongly recommended)?" "User Accounts"
if [ $? -eq 1 ] ; then
	_duser
fi