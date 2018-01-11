#!/bin/sh

# Dektop jumpstarter for FreeBSD 10/11
# by Felix Caffier
# http://www.trisymphony.com
# revision 2018-01-12


# ------------------------------------ Notes

# GNOME seems to work (and look) best - recommended desktop
# KDE untested, because KDE4 is so old now
# CINNAMON produces only a black screen... help?

# Code::Blocks install is currently borked in 11.1 (startup crash)
# so you probably need to manually install it from ports

# anyone up for semi-automatic GPU detection and driver installation?


# ------------------------------------ globals & setup

# control vars and strings
INST_PKG=1 # assume a fresh install
FBSD_UPD=1 # fetch security patches by default
INST_XORG=1 # needed for every desktop
INST_XFCE=0
INST_GNOME=0
INST_CINNAMON=0
INST_KDE=0 # possible conflict with VLC
INST_Office=0
INST_VLC=0 # possible conflict with KDE
INST_Firefox=0
INST_Chromium=0
INST_CodeBlocks=0
INST_Linux=0

# pretty colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# ------------------------------------ welcome message

clear
echo -e "${CYAN}FreeBSD Desktop installer for FreeBSD 10/11
by Felix Caffier (http://www.trisymphony.com)${NC}

This script will install PKG, X, a Desktop Environment of your choice,
some optional Desktop software and set up a 'wheel video' user, but
it will ${YELLOW}not${NC} install nvidia/amd/... graphics drivers!

If you made a mistake answering the questions, you can quit out 
of the installer by pressing ${CYAN}CTRL+C${NC} and then start again.
"


# ------------------------------------ checks

# system queries
MY_NAME=$(whoami)
MY_ID=$(id -u)
MY_ARCH=$(uname -m)

# root user check
if [ "$MY_ID" -ne 0 ]; then
	echo -e "[ ${RED}ERROR${NC} ]  This script needs to be run as ${CYAN}root user${NC}.
	"
	exit 1
fi
echo -e "[ ${GREEN}INFO${NC} ]  Running as root"

# machine type check
echo -e "[ ${GREEN}INFO${NC} ]  Processor architecture: $MY_ARCH"

# look for PKG
case "$(/usr/sbin/pkg -N 2>&1)" in
	*" not "*) 
		echo -e "[ ${GREEN}INFO${NC} ]  PKG will be bootstrapped" 
		INST_PKG=1
		;;
	*) 
		echo -e "[ ${YELLOW}NOTE${NC} ]  PKG was bootstrapped before"
		INST_PKG=0
		;;
esac

# command line overrides
while getopts ":xu" opt; do
	case $opt in
		x)
			INST_XORG=0
			echo -e "[ ${YELLOW}NOTE${NC} ]  -x: Xorg will not be installed!"
			;;
		u)
			FBSD_UPD=0
			echo -e "[ ${YELLOW}NOTE${NC} ]  -u: Skipping FreeBSD security patches!"
			;;
	esac
done

# network connection check
if nc -zw1 8.8.8.8 443 > /dev/null 2>&1 ; then
	echo -e "[ ${GREEN}INFO${NC} ]  Internet connection verified"
	echo -e "[ ${GREEN}INFO${NC} ]  Proceeding with regular installation...
	"
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Could not verify internet connection!"
	echo -e "[ ${YELLOW}NOTE${NC} ]  You must be online for this script to work!"
	echo -e "[ ${YELLOW}NOTE${NC} ]  Proceed with caution...
	"
fi


# ------------------------------------ questions

# INST_XORG - default 1, set script argument -x to skip
# read -p "Install XORG (required for any Desktop)? [y/N] " response
# if echo "$response" | grep -iq "^y" ; then
# 	INST_XORG=1
# else
# 	echo -e "[ ${YELLOW}NOTE${NC} ]  Skipping XORG. Desktops might not work!"
# fi

# ask INST_XFCE
read -p "Install XFCE as main Desktop? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_XFCE=1
else
	# ask INST_GNOME
	read -p "Install GNOME as main Desktop instead? [y/N] " response
	if echo "$response" | grep -iq "^y" ; then
		INST_GNOME=1
	else
	
		# ask INST_CINNAMON
		read -p "Would you rather like the Cinnamon Desktop instead? [y/N] " response
		if echo "$response" | grep -iq "^y" ; then
			INST_CINNAMON=1
		else

			# ask INST_KDE
			read -p "Last option, install KDE as main Desktop instead? [y/N] " response
			if echo "$response" | grep -iq "^y" ; then
				INST_KDE=1
			else
				echo -e "[ ${YELLOW}NOTE${NC} ]  No desktop will be installed!"
			fi
			
		fi
	fi
fi

# ask INST_VLC, but only if KDE is not selected
if [ "$INST_KDE" -eq 0 ] ; then
	read -p "Install VLC media player (video & audio)? [y/N] " response
	if echo "$response" | grep -iq "^y" ; then
		INST_VLC=1
	else
		INST_VLC=0
	fi
fi

# ask INST_Firefox
read -p "Install Firefox (Mozilla web browser)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Firefox=1
else
	INST_Firefox=0
fi

# ask INST_Chromium
read -p "Install Chromium (Chrome web browser)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Chromium=1
else
	INST_Chromium=0
fi

# ask INST_Office
read -p "Install LibreOffice (word processor/spreadsheet/etc)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Office=1
else
	INST_Office=0
fi

# ask INST_CodeBlocks
read -p "Install CodeBlocks (programming IDE)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_CodeBlocks=1
else
	INST_CodeBlocks=0
fi

# ask INST_Linux
read -p "Install Linux compat layer (CentOS 7)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Linux=1
else
	INST_Linux=0
fi


# ------------------------------------ confirmation

echo ""
echo -e "[ ${YELLOW}NOTE${NC} ]  Last chance to turn back!"
read -p "Is everything above correct? Start installation now? [y/N] " response
if echo "$response" | grep -iq "^y" ;
then
	echo "" # starting installation now
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Aborting installation.
	"
	exit 5
fi


# ------------------------------------ user account creation

echo -e "[ ${GREEN}INFO${NC} ]  Creating new user account. Please follow the instructions
on screen, and remember to add yourself to the '${YELLOW}wheel video${NC}'
groups and give yourself a proper ${YELLOW}password${NC}!
"

if adduser ; then
	echo ""	# continue
else
	echo -e "[ ${RED}ERROR${NC} ]  User creation failed!
	"
	exit 1
fi


# ------------------------------------ INSTALLATION

# security patches
if [ "$FBSD_UPD" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Applying latest FreeBSD security patches
	"
	freebsd-update fetch install
	echo ""
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Skipping FreeBSD security patches"
fi

# PKG
if [ "$INST_PKG" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Bootstrapping PKG
	"
	env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg
	echo ""
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Skipping PKG bootstrap"
fi

if pkg update ; then
	echo "" # pkg was updated, we can continue
else
	echo -e "[ ${RED}ERROR${NC} ]  PKG update failed
	"
	exit 1
fi

# XORG
if [ "$INST_XORG" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing XORG
	"
	pkg install -y xorg
	echo ""
	pkg install -y urwfonts
	echo ""
	
fi

# XFCE
if [ "$INST_XFCE" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing XFCE
	"
	pkg install -y xfce
	echo ""
	pkg install -y gdm
	echo "
# ---- installDesktop script: XFCE installation
proc		/proc	procfs	rw	0	0" >> "/etc/fstab"
	echo "
# ---- installDesktop script: XFCE installation
dbus_enable=\"YES\"
hald_enable=\"YES\"
gdm_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi

# GNOME
if [ "$INST_GNOME" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing GNOME"
	echo ""
	pkg install -y gnome3
	echo ""
	pkg install -y gnome-tweak-tool
	echo "
# ---- installDesktop script: GNOME installation
proc		/proc	procfs	rw	0	0" >> "/etc/fstab"
	echo "
# ---- installDesktop script: GNOME installation
dbus_enable=\"YES\"
hald_enable=\"YES\"
gdm_enable=\"YES\"
gnome_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi

# CINNAMON
if [ "$INST_CINNAMON" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Cinnamon"
	echo ""
	pkg install -y cinnamon
	echo ""
	pkg install -y gdm
	echo "
# ---- installDesktop script: Cinnamon installation
proc		/proc	procfs	rw	0	0" >> "/etc/fstab"
	echo "
# ---- installDesktop script: Cinnamon installation
dbus_enable=\"YES\"
hald_enable=\"YES\"
gdm_enable=\"YES\"
cinnamon_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi

# KDE
if [ "$INST_KDE" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing KDE"
	echo ""
	pkg install -y kde
	echo "
# ---- installDesktop script: KDE installation
proc		/proc	procfs	rw	0	0" >> "/etc/fstab"
	echo "
# ---- installDesktop script: KDE installation
dbus_enable=\"YES\"
hald_enable=\"YES\"
kdm4_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi

# FIREFOX
if [ "$INST_Firefox" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Firefox Browser
	"
	pkg install -y firefox
	echo ""
fi

# Chromium
if [ "$INST_Chromium" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Chromium Browser
	"
	pkg install -y chromium
	echo "
# ---- installDesktop script: Chromium browser
kern.ipc.shm_allow_removed=1" >> "/etc/sysctl.conf"
	echo ""
fi

# VLC
if [ "$INST_VLC" -eq 1 ] && [ "$INST_KDE" -eq 0 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing VLC Media Player
	"
	pkg install -y vlc
	echo ""
fi

# OFFICE
if [ "$INST_Office" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing LibreOffice
	"
	pkg install -y libreoffice
	echo ""
fi

# CodeBlocks
if [ "$INST_CodeBlocks" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing CodeBlocks IDE
	"
	pkg install -y codeblocks
	echo ""
fi

# LINUX
if [ "$INST_Linux" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Linux compat layer"
	case "$MY_ARCH" in
		*"64"*)
			echo -e "[ ${GREEN}INFO${NC} ]  Loading 64bit linux kernel module"
			kldload linux64
			;;
		*)
			echo -e "[ ${GREEN}NOTE${NC} ]  Loading 32bit linux kernel module"
			kldload linux
			;;
	esac
	echo ""
	pkg install -y linux-c7
	echo "
# ---- installDesktop script: LINUX compat
linux_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi


# ------------------------------------ other small helpers

echo -e "[ ${GREEN}NOTE${NC} ]  Installing additional CLI tools

----- NANO"
pkg install -y nano
echo "
----- VIM"
pkg install -y vim
echo "
----- UNAR"
pkg install -y unar
echo "
----- SYSINFO"
pkg install -y sysinfo
echo "
----- HTOP"
pkg install -y htop
echo ""


# ------------------------------------ finalizing

echo -e "[ ${YELLOW}NOTE${NC} ]  Installation complete. Please restart your system!
Either type ${CYAN}shutdown -r now${NC} to reboot now, or reboot later and 
manually install additional applications.
"

# EOF


# ------------------------------------ scratchpad - TODO

# /etc/X11/xorg.conf
# LOAD "freetype"
# FontPath "/user/local/share/fonts/bitstream-vera/"
# FontPath "/user/local/share/fonts/Droid/"
# FontPath "/usr/local/share/fonts/urwfonts/"


# ~/.config/fontconfig/.fonts.config

# <?xml version="1.0"?>
# <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
# <fontconfig>
#   <match target="font">
#     <edit name="antialias" mode="assign"><bool>true</bool></edit>
#   </match>
#   <match target="font">
#     <edit name="hintstyle" mode="assign"><const>hintnone</const></edit>
#   </match>
#   <match target="font">
#    <edit mode="assign" name="hinting"><bool>false</bool></edit>
#   </match>
# </fontconfig>

#nvidia-driver
#nvidia-xconfig
#nvidia-settings
