#!/bin/sh

# FreeBSDesktop
# by Felix Caffier
# http://www.trisymphony.com


VER='13.2'

CWD="$(dirname "$0")"
. ${CWD}/include/constants.sh			# global constants
. ${CWD}/include/kbd_str.sh				# keyboard constants
. ${CWD}/include/variables.sh			# control variables
. ${CWD}/include/functions.sh			# general functions
. ${CWD}/include/functions_dia.sh		# dialog functions


# ------------------------------------ welcome message & checks

VDATE="$(cat "${CWD}/buildversion")"

clear
printf "${CC}FreeBSDesktop for v${VER} (build ${VDATE})${NC}\n\n"
printf "This script will install PKG, X, a desktop environment with theming, some\n"
printf "optional Desktop software, a login manager, and set up users.\n\n"
printf "If you made a mistake answering the questions, you can quit out\n"
printf "of the installer by pressing ${CC}CTRL+C${NC} and then start again.\n\n"

. ${CWD}/include/run_checks.sh
_anykey


# ------------------------------------ configure installation

_dkbd			# select keymap
_dmirror		# select mirror
_dde			# select desktop environment
_dlogin			# select login manager
_dxsoft			# select GUI software
_dcsoft			# select CLI software
_dvselect		# select video driver

_dn "Last chance to turn back! Start installation now?\n" "Confirmation"
if [ $? -eq 0 ] ; then
	_abort
fi


# ------------------------------------ account creation

clear
printf "[ ${CG}NOTE${NC} ]  Default account setup\n\n"
. ${CWD}/include/install_skel.sh

_dn "Do you want to add new users to the system (strongly recommended)?" "User Accounts"
if [ $? -eq 1 ] ; then
	_duser
fi


# ------------------------------------ run installation

clear
_patches
_pkgboot

if [ "$INST_MATE" -eq 1 ] ; then
	. ${CWD}/desktops/desktop-mate.sh
elif [ "$INST_CINNAMON" -eq 1 ] ; then
	. ${CWD}/desktops/desktop-cinnamon.sh
fi

if [ "$INST_SLIM" -eq 1 ] ; then
	. ${CWD}/desktops/login-slim.sh
elif [ "$INST_LIGHTDM" -eq 1 ] ; then
	. ${CWD}/desktops/login-lightdm.sh
fi

. ${CWD}/include/install_guiapps.sh
. ${CWD}/include/install_cliapps.sh
. ${CWD}/include/install_video.sh
. ${CWD}/include/install_kbd.sh


# ------------------------------------ final check

clear
printf "[ ${CG}NOTE${NC} ]  Time for a final update check!\n\n"
pkg upgrade -y
echo ""

printf "[ ${CY}NOTE${NC} ]  Installation complete. Please restart your system!\n"
printf "Either type ${CC}shutdown -r now${NC} to reboot now, or manually add\n"
printf "other applications with ${CC}pkg install §name${NC} and reboot later.\n\n"
