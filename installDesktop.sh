#!/bin/sh

# Dektop jumpstarter for FreeBSD 10/11
# by Felix Caffier
# http://www.trisymphony.com
# revision 2018-01-01


# ------------------------------------ Notes

# GNOME seems to work (and look) best - recommended desktop
# KDE untested, because KDE4 is so old now
# CINNAMON produces only a black screen... help?

# Code::Blocks install is currently borked in 11.1 (startup crash)
# so you probably need to manually install it from ports

# anyone up for semi-automatic GPU detection and driver installation?


# ------------------------------------ globals & setup

# control vars and strings
INST_PKG=1
INST_XORG=0
INST_XFCE=0
INST_GNOME=0
INST_CINNAMON=0
INST_KDE=0
INST_Office=0
INST_VLC=0
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
some optional Desktop software and set up a 'wheel/video' user, but
it will ${YELLOW}not${NC} install nvidia/amd/... graphics drivers!
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
		echo -e "[ ${GREEN}INFO${NC} ]  PKG needs to be bootstrapped" 
		INST_PKG=1
		;;
	*) 
		echo -e "[ ${YELLOW}NOTE${NC} ]  PKG was bootstrapped before"
		INST_PKG=0
		;;
esac

# continue
echo -e "[ ${GREEN}INFO${NC} ]  Proceeding with regular installation...
"


# ------------------------------------ questions

# ask INST_XORG
read -p "Install XORG (required for any Desktop)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_XORG=1
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Skipping XORG. Desktops might not work!"
fi

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

# ask INST_VLC
read -p "Install VLC media player (video & audio)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_VLC=1
else
	INST_VLC=0
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

echo -e "[ ${GREEN}INFO${NC} ]  Creating new user account. Please follow the
instructions on screen, and remember to add yourself to the ${YELLOW}wheel${NC}
and ${YELLOW}video${NC} groups and give yourself a proper ${YELLOW}password${NC}!
"

if adduser ; then
	echo ""	# continue
else
	echo -e "[ ${RED}ERROR${NC} ]  User creation failed!
	"
	exit 1
fi


# ------------------------------------ INSTALLATION

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
	echo "y" | pkg install xorg
	echo ""
	echo "y" | pkg install urwfonts
	echo ""
	
fi

# XFCE
if [ "$INST_XFCE" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing XFCE
	"
	echo "y" | pkg install xfce
	echo ""
	echo "y" | pkg install gdm
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
	echo "y" | pkg install gnome3
	echo ""
	echo "y" | pkg install gnome-tweak-tool
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
	echo "y" | pkg install cinnamon
	echo ""
	echo "y" | pkg install gdm
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
	echo "y" | pkg install kde
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
	echo "y" | pkg install firefox
	echo ""
fi

# Chromium
if [ "$INST_Chromium" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Chromium Browser
	"
	echo "y" | pkg install chromium
	echo "
# ---- installDesktop script: Chromium browser
kern.ipc.shm_allow_removed=1" >> "/etc/sysctl.conf"
	echo ""
fi

# VLC
if [ "$INST_VLC" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing VLC Media Player
	"
	echo "y" | pkg install vlc
	echo ""
fi

# OFFICE
if [ "$INST_Office" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing LibreOffice
	"
	echo "y" | pkg install libreoffice
	echo ""
fi

# CodeBlocks
if [ "$INST_CodeBlocks" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing CodeBlocks IDE
	"
	echo "y" | pkg install codeblocks
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
	echo "y" | pkg install linux-c7
	echo "
# ---- installDesktop script: LINUX compat
linux_enable=\"YES\"" >> "/etc/rc.conf"
	echo ""
fi


# ------------------------------------ other small helpers

echo -e "[ ${GREEN}NOTE${NC} ]  Installing additional CLI tools

----- NANO"
echo "y" | pkg install nano
echo "
----- VIM"
echo "y" | pkg install vim
echo "
----- UNAR"
echo "y" | pkg install unar
echo "
----- SYSINFO"
echo "y" | pkg install sysinfo
echo "
----- HTOP"
echo "y" | pkg install htop
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
