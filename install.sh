#!/bin/sh

# DarkMate Desktop for FreeBSD 12.0
# by Felix Caffier
# http://www.trisymphony.com
# revision 2019-07-04, now using SKEL


# ------------------------------------ Notes

# Just one desktop (MATE) - but nicely themed.
# More programs to select from than ever before!

# ": not found :" error is caused by wrong line endings! If you edit
# this script, make sure to save LF only, not CR or CR/LF!

# startup options:
# -x  Do not explicitly install XORG
# -u  Run "freebsd-update" before installation


# ------------------------------------ globals & setup

# control vars and strings
INST_PKG=1			# assume a fresh install
MIRR_PKG=''			# mirrors for PKG: 0 "", 1 "eu.", 2 "us-east.", 3 "us-west."
FBSD_UPD=0			# fetch security patches by default
INST_XORG=1			# needed for every desktop
INST_MATE=1			# nice desktop environment

INST_Firefox=0		# free browser
INST_Chromium=0		# google browser
INST_Thunderbird=0	# mail client
INST_Office=0		# libreoffice
INST_VLC=0			# media playback

INST_CodeLite=0		# c++ IDE
INST_GCC=0			# GNU alternative for CLANG

INST_ART=0			# GIMP, Inkscape, Krita
INST_3D=0			# Blender, Wings
INST_CHAT=0			# Pidgin, Hexchat
INST_MUSIC=0		# Audacity, Ardour

KBD_LANG='us'		# keyboard layout (language)
KBD_VAR=''			# keyboard layout (variant)

# pretty colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# ------------------------------------ welcome message

clear
echo -e "${CYAN}DarkMate setup script for FreeBSD 12.0
by Felix Caffier (http://www.trisymphony.com)${NC}

This script will install PKG, X, the MATE desktop with theming, some optional
Desktop software, and set up a 'wheel video' user. For the best user experience,
you should install video drivers (e.g. nVidia) after a reboot.

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
			echo -e "[ ${YELLOW}NOTE${NC} ]  -x: Xorg will not be explicitly installed!"
			;;
		u)
			FBSD_UPD=1
			echo -e "[ ${YELLOW}NOTE${NC} ]  -u: Installing FreeBSD updates! [ ${CYAN}:q${NC} ] to continue after updates."
			;;
	esac
done

# network connection check
if nc -zw1 8.8.8.8 443 > /dev/null 2>&1 ; then
	# continue
else
	echo -e "[ ${YELLOW}NOTE${NC} ]  Could not verify internet connection!"
	echo -e "[ ${YELLOW}NOTE${NC} ]  You must be online for this script to work!"
	echo -e "[ ${YELLOW}NOTE${NC} ]  Proceed with caution...
	"
fi


# ------------------------------------ keyboard selection

echo -e "[ ${GREEN}INFO${NC} ]  The default keymap for MATE and the login is '${YELLOW}us${NC}' (English).
You can change this now using your 2-letter languange code like '${YELLOW}de${NC}' (German),
'${YELLOW}fr${NC}' (French), '${YELLOW}dk${NC}' (Danish) etc., and a variant like '${YELLOW}oss${NC}' or '${YELLOW}dvorak${NC}' if
needed in the 2nd step. You can change your keyboard mapping later at any point.
"

read -p "Which language does your keyboard have? [us] " response
if [ -z "$response" ] ; then
	echo "Choosing the default US layout.
	"
else
	KBD_LANG=$response
fi

read -p "Which language variant does your keyboard use? [] " response
if [ -z "$response" ] ; then
	echo "Choosing no special layout variant.
	"
else
	KBD_VAR=$response
fi


# ------------------------------------ questions

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

# ask INST_Thunderbird
read -p "Install Thunderbird (E-Mail Client)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Thunderbird=1
else
	INST_Thunderbird=0
fi

# ask INST_Office
read -p "Install Office (LibreOffice, SANE, ...)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_Office=1
else
	INST_Office=0
fi

# ask INST_VLC
read -p "Install VLC media player (video & audio)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_VLC=1
else
	INST_VLC=0
fi

# ask INST_CodeLite
read -p "Install CodeLite (programming IDE)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_CodeLite=1
else
	INST_CodeLite=0
fi
# follow-up: ask INST_GCC
if [ "$INST_CodeLite" -eq 1 ] ; then
	read -p "Install GCC (alongside CLANG)? [y/N] " response
	if echo "$response" | grep -iq "^y" ; then
		INST_GCC=1
	else
		INST_GCC=0
	fi
fi

# ask INST_ART
read -p "Install 2D Art software (GIMP, Inkscape, Krita, ...)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_ART=1
else
	INST_ART=0
fi

# ask INST_3D
read -p "Install 3D software (Blender, Wings, ...)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_3D=1
else
	INST_3D=0
fi

# ask INST_CHAT
read -p "Install Chat software (Pidgin, HexChat, ...)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_CHAT=1
else
	INST_CHAT=0
fi

# ask INST_MUSIC
read -p "Install Music software (Audacity, Ardour, ...)? [y/N] " response
if echo "$response" | grep -iq "^y" ; then
	INST_MUSIC=1
else
	INST_MUSIC=0
fi

# ask PKG mirror
read -p "PKG Mirror: What is your location? 0:World, 1:EU, 2:US-East, 3:US-West [0] " response
if [ "$response" -eq 1 ] ; then
	MIRR_PKG='eu.'
elif [ "$response" -eq 2 ] ; then
	MIRR_PKG='us-east.'
elif [ "$response" -eq 3 ] ; then
	MIRR_PKG='us-west.'
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


# ------------------------------------ making SKEL changes

# creating folders
mkdir /usr/share/skel/Documents
mkdir /usr/share/skel/Downloads
mkdir /usr/share/skel/Music
mkdir /usr/share/skel/Pictures
mkdir /usr/share/skel/Programming
mkdir /usr/share/skel/Videos

# startup mate session
touch /usr/share/skel/dot.xinitrc
echo "# ---- installDesktop script: MATE installation
exec mate-session" > /usr/share/skel/dot.xinitrc

# transparent separators
mkdir -p /usr/share/skel/dot.config/gtk-3.0
touch /usr/share/skel/dot.config/gtk-3.0/gtk.css
echo "PanelSeparator {
	color: transparent;
}
" > /usr/share/skel/dot.config/gtk-3.0/gtk.css

chown -R root:wheel /usr/share/skel 


# ------------------------------------ user account creation

echo -e "[ ${GREEN}INFO${NC} ]  Creating new user account. Please follow the instructions
on screen, and remember to invite yourself to the '${YELLOW}wheel video${NC}'
groups and give yourself a proper ${YELLOW}password${NC}!

The installer also assumes your home folder is located in ${YELLOW}/home${NC}.
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

mkdir -p /usr/local/etc/pkg/repos
touch /usr/local/etc/pkg/repos/FreeBSD.conf

echo 'FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  enabled: yes
}' > /usr/local/etc/pkg/repos/FreeBSD.conf

sed -i ".bak" "s/pkg.FreeBSD.org/pkg.${MIRR_PKG}FreeBSD.org/" /usr/local/etc/pkg/repos/FreeBSD.conf
rm /usr/local/etc/pkg/repos/FreeBSD.conf.bak

if pkg update -f ; then
	echo "" # pkg was updated, we can continue
else
	echo -e "[ ${RED}ERROR${NC} ]  PKG update failed
	"
	exit 1
fi

# wget
echo -e "[ ${GREEN}NOTE${NC} ]  Installing wget
"
pkg install -y wget
echo ""

# XORG
if [ "$INST_XORG" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing XORG
	"
	pkg install -y xorg
	echo ""
	
	pkg install -y urwfonts
	echo ""

	pkg install -y mesa-demos
	echo ""
	
fi

# MATE
if [ "$INST_MATE" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing MATE Desktop
	"
	pkg install -y mate
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Mounting procfs
	"
	if grep -q procfs /etc/fstab ; then
		# found a procfs entry already
		# should it be forcefully replaced? -> SED
	else
		# add procfs entry
		echo "
# ---- installDesktop script: MATE installation
proc		/proc	procfs	rw	0	0" >> "/etc/fstab"		
	fi
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing SLiM
	"
	pkg install -y slim
	echo ""
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing SLiM theme
	"
	cd /usr/local/share/slim/themes
	if fetch http://daemon-notes.com/downloads/assets/themes/slim-freebsd.tar.bz2 ; then
		tar jxvf slim-freebsd.tar.bz2
		rm slim-freebsd.tar.bz2
		sed -i ".bak" "s/current_theme.*/current_theme		freebsd-1920x1080/" /usr/local/etc/slim.conf
	fi
	echo ""
	
	# set keyboard.conf for SLiM
	mkdir -p /etc/X11/xorg.conf.d
	chmod 755 /etc/X11/xorg.conf.d
	touch /etc/X11/xorg.conf.d/10-keyboard.conf
	chmod 755 /etc/X11/xorg.conf.d/10-keyboard.conf
	echo "# keyboard layout for SLiM (Login Manager)
Section \"InputClass\"
	Identifier \"Keyboard0\"
	Driver \"kbd\"
	MatchIsKeyboard \"on\"
	Option \"XkbModel\" \"pc105\"
	Option \"XkbRules\" \"xorg\"
	Option \"XkbLayout\" \"${KBD_LANG}\"" > /etc/X11/xorg.conf.d/10-keyboard.conf
	if [ -z "$KBD_VAR" ] ; then 
		echo "	#Option \"XkbVariant\" \"\"" >> /etc/X11/xorg.conf.d/10-keyboard.conf
	else
		echo "	Option \"XkbVariant\" \"${KBD_VAR}\"" >> /etc/X11/xorg.conf.d/10-keyboard.conf
	fi
	echo "EndSection
	" >> /etc/X11/xorg.conf.d/10-keyboard.conf
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Configuring rc.conf
	"
	if grep -q moused_enable /etc/rc.conf ; then
		# replace moused entry
		sed -i ".bak" "s/moused_enable.*/moused_enable=\"YES\"/" /etc/rc.conf
	else
		# add moused entry
		echo "
# ---- installDesktop script: MATE installation
moused_enable=\"YES\"" >> /etc/rc.conf
	fi
	if grep -q dbus_enable /etc/rc.conf ; then
		# replace dbus entry
		sed -i ".bak" "s/dbus_enable.*/dbus_enable=\"YES\"/" /etc/rc.conf
	else
		# add dbus entry
		echo "
# ---- installDesktop script: MATE installation
dbus_enable=\"YES\"" >> /etc/rc.conf
	fi
	if grep -q hald_enable /etc/rc.conf ; then
		# replace hald entry
		sed -i ".bak" "s/hald_enable.*/hald_enable=\"YES\"/" /etc/rc.conf
	else
		# add hald entry
		echo "
# ---- installDesktop script: MATE installation
hald_enable=\"YES\"" >> /etc/rc.conf
	fi
	if grep -q slim_enable /etc/rc.conf ; then
		# replace slim entry
		sed -i ".bak" "s/slim_enable.*/slim_enable=\"YES\"/" /etc/rc.conf
	else
		# add slim entry
		echo "
# ---- installDesktop script: MATE installation
slim_enable=\"YES\"" >> /etc/rc.conf
	fi

	# theming
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Brisk Menu
	"
	pkg install -y brisk-menu
	echo ""	
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Arc Themes
	"
	pkg install -y gtk-arc-themes
	echo ""
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Papirus icons
	"
	wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh | env DESTDIR="/usr/local/share/icons" sh
	echo ""
	
	# create a theme override file
	mkdir -p /usr/local/etc/dconf/profile
	mkdir -p /usr/local/etc/dconf/db/mate.d
	
	echo "user-db:user
system-db:mate
" > /usr/local/etc/dconf/profile/user
	chmod 775 /usr/local/etc/dconf/profile/user
	
	echo "[org/gtk/settings/file-chooser]
sort-column='name'
sidebar-width=156
window-position=(429, 139)
show-size-column=true
show-hidden=false
window-size=(1063, 797)
sort-directories-first=false
date-format='regular'
sort-order='ascending'
location-mode='path-bar'
[org/mate/notification-daemon]
popup-location='top_right'
use-active-monitor=true
theme='slider'
[org/mate/screensaver]
themes=@as []
mode='blank-only'
[org/mate/desktop/peripherals/keyboard/kbd]" > /usr/local/etc/dconf/db/mate.d/darkmate-settings

if [ -z "$KBD_VAR" ] ; then
	echo "layouts=['${KBD_LANG}']" >> /usr/local/etc/dconf/db/mate.d/darkmate-settings
else
	echo "layouts=['${KBD_LANG}\t${KBD_VAR}']" >> /usr/local/etc/dconf/db/mate.d/darkmate-settings
fi

echo "options=@as []
[org/mate/desktop/applications/terminal]
exec='mate-terminal'
[org/mate/desktop/background]
color-shading-type='vertical-gradient'
primary-color='rgb(39,88,126)'
picture-options='zoom'
picture-filename='/usr/local/share/backgrounds/mate/abstract/Arc-Colors-Transparent-Wallpaper.png'
secondary-color='rgb(98,127,90)'
[org/mate/desktop/interface]
font-name='Sans 10'
gtk-color-scheme='menu_bg: #383c4a'
icon-theme='Papirus-Dark'
gtk-theme='Arc-Dark'
menus-have-icons=true
[org/mate/marco/general]
compositing-manager=true
theme='Arc-Dark'
num-workspaces=2
[org/mate/caja/preferences]
default-folder-viewer='list-view'
[org/mate/caja/list-view]
default-visible-columns=['name', 'size', 'type', 'date_modified', 'permissions']
default-column-order=['name', 'size', 'type', 'date_modified', 'date_accessed', 'group', 'where', 'mime_type', 'octal_permissions', 'owner', 'permissions', 'size_on_disk', 'Xattr::Tags']
[org/mate/panel/general]
show-program-list=false
object-id-list=['notification-area', 'clock', 'object-0', 'object-1', 'object-2', 'object-3', 'object-4', 'object-5']
toplevel-id-list=['top']
[org/mate/panel/toplevels/top]
expand=true
orientation='bottom'
screen=0
y-bottom=0
size=24
y=1056
[org/mate/panel/toplevels/toplevel-0]
enable-buttons=true
orientation='top'
enable-arrows=true
[org/mate/panel/objects/object-4]
applet-iid='WnckletFactory::WorkspaceSwitcherApplet'
locked=true
toplevel-id='top'
position=165
object-type='applet'
panel-right-stick=true
[org/mate/panel/objects/object-5]
locked=true
toplevel-id='top'
position=10
object-type='separator'
panel-right-stick=true
[org/mate/panel/objects/clock]
applet-iid='ClockAppletFactory::ClockApplet'
locked=true
toplevel-id='top'
position=46
object-type='applet'
panel-right-stick=true
[org/mate/panel/objects/clock/prefs]
show-temperature=false
show-date=false
format='24-hour'
custom-format=''
show-seconds=false
show-weather=false
[org/mate/panel/objects/notification-area]
applet-iid='NotificationAreaAppletFactory::NotificationArea'
locked=true
toplevel-id='top'
position=80
object-type='applet'
panel-right-stick=true
[org/mate/panel/objects/object-0]
applet-iid='BriskMenuFactory::BriskMenu'
locked=true
toplevel-id='top'
position=0
object-type='applet'
panel-right-stick=false
[org/mate/panel/objects/object-1]
locked=true
launcher-location='/usr/local/share/applications/mate-terminal.desktop'
toplevel-id='top'
position=71
object-type='launcher'
panel-right-stick=false
[org/mate/panel/objects/object-2]
locked=true
launcher-location='/usr/local/share/applications/caja-browser.desktop'
toplevel-id='top'
position=95
object-type='launcher'
panel-right-stick=false
[org/mate/panel/objects/object-3]
applet-iid='WnckletFactory::WindowListApplet'
locked=true
toplevel-id='top'
position=119
object-type='applet'
panel-right-stick=false
" >> /usr/local/etc/dconf/db/mate.d/darkmate-settings
	chmod 775 /usr/local/etc/dconf/db/mate.d/darkmate-settings
	
	# update dconf database
	dconf update
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
	if grep -q kern.ipc.shm_allow_removed /etc/sysctl.conf ; then
		# replace kern.ipc entry
		sed -i ".bak" "s/kern.ipc.shm_allow_removed.*/kern.ipc.shm_allow_removed=1/" /etc/sysctl.conf
	else
		# add kern.ipc entry
		echo "
# ---- installDesktop script: Chromium browser
kern.ipc.shm_allow_removed=1" >> /etc/sysctl.conf
	fi
	echo ""
fi

# Thunderbird
if [ "$INST_Thunderbird" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Thunderbird
	"
	pkg install -y thunderbird
	echo ""
	pkg install -y thunderbird-dictionaries
	echo ""
fi

# VLC
if [ "$INST_VLC" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing VLC Media Player
	"
	pkg install -y vlc3
	echo ""
fi

# OFFICE
if [ "$INST_Office" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing LibreOffice
	"
	pkg install -y libreoffice
	echo ""
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Xsane
	"
	pkg install -y xsane
	echo ""
fi

# CodeLite
if [ "$INST_CodeLite" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing CodeLite IDE
	"
	pkg install -y codelite
	echo ""
fi

# GCC
if [ "$INST_GCC" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing GCC
	"
	pkg install -y gcc
	echo ""
fi

# 2D ART
if [ "$INST_ART" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing GIMP
	"
	pkg install -y gimp
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Inkscape
	"
	pkg install -y inkscape
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Krita
	"
	pkg install -y krita
	echo ""
fi

# 3D
if [ "$INST_3D" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Blender
	"
	pkg install -y blender
	echo ""
	
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Wings3D
	"
	pkg install -y wings
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Installing nVidia Texture Tools
	"
	pkg install -y nvidia-texture-tools
	echo ""
fi

# CHAT
if [ "$INST_CHAT" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Pidgin
	"
	pkg install -y -g 'pidgin*'
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Hexchat
	"
	pkg install -y hexchat
	echo ""
fi

# MUSIC
if [ "$INST_MUSIC" -eq 1 ] ; then
	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Audacity
	"
	pkg install -y audacity
	echo ""

	echo -e "[ ${GREEN}NOTE${NC} ]  Installing Ardour
	"
	pkg install -y ardour5
	echo ""
fi

# small helpers
echo -e "[ ${GREEN}NOTE${NC} ]  Installing additional tools

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
if [ "$INST_XORG" -eq 1 ] ; then
	echo "----- GEANY"
	pkg install -y geany
	echo ""
fi


# ------------------------------------ finalizing

echo -e "[ ${GREEN}NOTE${NC} ]  Time for a final update check!
"
pkg upgrade
echo ""

echo -e "[ ${YELLOW}NOTE${NC} ]  Installation complete. Please restart your system!
Either type ${CYAN}shutdown -r now${NC} to reboot now, or reboot later and 
manually install additional applications.
"

# EOF


# ------------------------------------ scratchpad - TODO

# --- what's up with fonts? Are these lines needed?

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


# --- anyone up for semi-automatic GPU detection and driver installation?

# nvidia-driver
# nvidia-xconfig
# nvidia-settings
