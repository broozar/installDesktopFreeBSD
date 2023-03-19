#!/bin/sh
# gsettings readout and replacement

CWD="$(dirname "$0")"
. ${CWD}/../src/include/constants.sh			# global constants
. ${CWD}/../src/include/kbd_str.sh				# keyboard constants
. ${CWD}/../src/include/variables.sh			# control variables
. ${CWD}/../src/include/functions.sh			# general functions
. ${CWD}/../src/include/functions_dia.sh		# dialog functions

cp ${CWD}/../config/gterm-settings /tmp
chmod 775 /tmp/gterm-settings

TID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sed -i ".bak" "s/#####TERM/${TID}/" /tmp/gterm-settings

cat /tmp/gterm-settings