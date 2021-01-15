#!/bin/sh

# DarkMate Desktop for FreeBSD 12.1
# by Felix Caffier
# http://www.trisymphony.com
# rev. 2020-05-02 with custom theming, github downloads and functions

# ----------------------------------------------------------------------
# ------------------------------------ Notes
# ----------------------------------------------------------------------

# Just one desktop (MATE) - but nicely themed.
# No big software selection, just a basic system!

# ": not found :" error is caused by wrong line endings! If you edit
# this script, make sure to save LF only, not CR or CR/LF!

# startup options:
# -x  Do not explicitly install XORG
# -u  Run "freebsd-update" before installation


# ----------------------------------------------------------------------
# ------------------------------------ globals & setup
# ----------------------------------------------------------------------

# ------------------------------------ control vars and strings

INST_PKG=1			# assume a fresh install
MIRR_PKG=''			# mirrors for PKG: 0 "", 1 "eu.", 2 "us-east.", 3 "us-west."
FBSD_UPD=0			# fetch security patches only if requested
INST_XORG=1			# needed for every desktop
INST_MATE=1			# nice desktop environment

INST_Firefox=0		# free browser
INST_Chromium=0		# google browser
INST_Thunderbird=0	# mail client
INST_Office=0		# libreoffice
INST_VLC=0			# media playback
INST_CPP=0			# C++ and IDE
INST_Java=0			# Java and IDE

INST_NVIDIA=0		# current NVIDIA drivers
INST_LEGVIDIA=0		# legacy NVIDIA drivers
INST_OLDVIDIA=0		# even older NVIDIA drivers
INST_DEADVIDIA=0	# decade old NVIDIA drivers

KBD_LANG=''			# keyboard layout (language)
KBD_VAR=''			# keyboard layout (variant)

# pretty colors!
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ------------------------------------ question templates

# yes/no question function - default NO
# return variable
# $1 question
_n () {
	read -p "$1" response
	if echo "$response" | grep -iq "^y" ; then
		return 1
	else
		return 0
	fi
}


# ----------------------------------------------------------------------
# ------------------------------------ user interaction
# ----------------------------------------------------------------------

# ------------------------------------ welcome message

clear
printf "${CYAN}DarkMate setup script for FreeBSD 12.1\nby Felix Caffier (http://www.trisymphony.com)${NC}\n\n"
printf "This script will install PKG, X, the MATE desktop with theming, some optional\n"
printf "Desktop software, SLiM, and set up users. Nvidia driver support is still\n"
printf "experimental and auto configuration is only supported for modern cards.\n\n"
printf "If you made a mistake answering the questions, you can quit out\n"
printf "of the installer by pressing ${CYAN}CTRL+C${NC} and then start again.\n\n"

# ------------------------------------ checks

c_root () {
	MY_ID=$(id -u)
	if [ "$MY_ID" -ne 0 ]; then
		printf "[ ${RED}ERROR${NC} ]  This script needs to be run as ${CYAN}root user${NC}.\n\n"
		exit 1
	fi
	printf "[ ${GREEN}INFO${NC} ]  Running as root\n"
}

c_arch () {
	MY_ARCH=$(uname -m)
	printf "[ ${GREEN}INFO${NC} ]  Processor architecture: $MY_ARCH\n"
}

c_pkg () {
	case "$(/usr/sbin/pkg -N 2>&1)" in
		*" not "*) 
			printf "[ ${GREEN}INFO${NC} ]  PKG will be bootstrapped\n"
			INST_PKG=1
			;;
		*) 
			printf "[ ${YELLOW}NOTE${NC} ]  PKG was bootstrapped before\n"
			INST_PKG=0
			;;
	esac
}

c_overrides () {
	while getopts ":xu" opt; do
		case $opt in
			x)
				INST_XORG=0
				printf "[ ${YELLOW}NOTE${NC} ]  -x: Xorg will not be explicitly installed!\n"
				;;
			u)
				FBSD_UPD=1
				printf "[ ${YELLOW}NOTE${NC} ]  -u: Installing FreeBSD updates! [ ${CYAN}:q${NC} ] to continue after updates.\n"
				;;
		esac
	done
}

c_network () {
	if nc -zw1 8.8.8.8 443 > /dev/null 2>&1 ; then
		printf "[ ${GREEN}INFO${NC} ]  Internet connection detected\n"
	else
		printf "[ ${YELLOW}NOTE${NC} ]  Could not verify internet connection!\n"
		printf "[ ${YELLOW}NOTE${NC} ]  You must be online for this script to work!\n"
		printf "[ ${YELLOW}NOTE${NC} ]  Proceed with caution...\n\n"
	fi
}

c_root
c_arch
c_pkg
c_overrides
c_network

# ------------------------------------ keyboard selection

kbd_welcome () {
	printf "[ ${GREEN}INFO${NC} ]  The default keymap for MATE and the login is '${CYAN}us${NC}' (English).\n"
	printf "You can change this now using your 2-letter languange code like '${CYAN}de${NC}' (German),\n"
	printf "'${CYAN}fr${NC}' (French), '${CYAN}dk${NC}' (Danish) etc., and a variant like '${CYAN}oss${NC}' or '${CYAN}dvorak${NC}' if\n"
	printf "needed in the 2nd step. You can change your keyboard mapping later at any point.\n\n"
}

kbd_read () {
	read -p "Which language does your keyboard have? [us] " response
	if [ -z "$response" ] ; then
		printf "Choosing the default US layout.\n\n"
	else
		KBD_LANG="$response"
	fi

	read -p "Which language variant does your keyboard use? [] " response
	if [ -z "$response" ] ; then
		printf "Choosing no special layout variant.\n\n"
	else
		KBD_VAR="$response"
	fi
}

kbd_welcome
kbd_read

# ------------------------------------ software

printf "[ ${GREEN}INFO${NC} ]  Software selection\n\n"

_n "Install Firefox (Mozilla web browser)? [y/N] "
INST_Firefox=$?

_n "Install Chromium (Chrome web browser)? [y/N] "
INST_Chromium=$?

_n "Install Thunderbird (E-Mail Client)? [y/N] "
INST_Thunderbird=$?

_n "Install Office (LibreOffice, SANE, CUPS)? [y/N] "
INST_Office=$?

_n "Install VLC media player (video & audio)? [y/N] "
INST_VLC=$?

_n "Install C++ and IDE (CodeLite)? [y/N] "
INST_CPP=$?

_n "Install Java and IDE (Netbeans)? [y/N] "
INST_Java=$?

echo ""

# ------------------------------------ nvidia drivers

printf "[ ${GREEN}INFO${NC} ]  Graphics drivers ${YELLOW}(experimental)${NC} - Select a driver based on the\n"
printf "model of your card. Only the latest drivers support auto configuration!\n\n"

_n "Install NVidia-current drivers (GeForce 600 and later)? [y/N] "
INST_NVIDIA=$?

if [ "$INST_NVIDIA" -eq 0 ] ; then
	_n "Install NVidia-legacy drivers instead (GeForce 500/600)? [y/N] "
	INST_LEGVIDIA=$?
fi
if [ "$INST_NVIDIA" -eq 0 -a "$INST_LEGVIDIA" -eq 0 ] ; then
	_n "Install NVidia-old drivers instead (GeForce 8 to 400)? [y/N] "
	INST_OLDVIDIA=$?
fi
if [ "$INST_NVIDIA" -eq 0 -a "$INST_LEGVIDIA" -eq 0 -a "$INST_OLDVIDIA" -eq 0 ] ; then
	_n "Install NVidia-ancient drivers instead (GeForce 6/7)? [y/N] "
	INST_DEADVIDIA=$?
fi

echo ""

# ------------------------------------ ask PKG mirror location

read -p "PKG Mirror: What is your location? 1:EU, 2:US-East, 3:US-West, 0:Other [0] " response
if [ "$response" = "1" ] ; then
	MIRR_PKG='eu.'
elif [ "$response" = "2" ] ; then
	MIRR_PKG='us-east.'
elif [ "$response" = "3" ] ; then
	MIRR_PKG='us-west.'
else
	echo "Choosing the default mirror."
fi

# ------------------------------------ confirmation

echo ""

printf "[ ${YELLOW}NOTE${NC} ]  Last chance to turn back!\n"
read -p "Is everything above correct? Start installation now? [y/N] " response
if echo "$response" | grep -iq "^y" ;
then
	echo "" # starting installation now
else
	printf "[ ${YELLOW}NOTE${NC} ]  Aborting installation.\n"
	exit 5
fi


# ----------------------------------------------------------------------
# ------------------------------------ user setup
# ----------------------------------------------------------------------

s_skel () {
	# home subfolders
	mkdir /usr/share/skel/Documents
	mkdir /usr/share/skel/Downloads
	mkdir /usr/share/skel/Media
	mkdir /usr/share/skel/Programming

	# MATE startup
	touch /usr/share/skel/dot.xinitrc
	echo "exec mate-session" > /usr/share/skel/dot.xinitrc

	# separators
	mkdir -p /usr/share/skel/dot.config/gtk-3.0
	touch /usr/share/skel/dot.config/gtk-3.0/gtk.css
	echo "PanelSeparator {
		color: transparent;
	}
	" > /usr/share/skel/dot.config/gtk-3.0/gtk.css

	# rights
	chown -R root:wheel /usr/share/skel 
}

s_user () {
	printf "[ ${GREEN}INFO${NC} ]  Creating new user account. Please follow the instructions.\n"
	if [ "$INST_Office" -eq 1 ] ; then
		printf "on screen, and remember to invite yourself to the '${CYAN}wheel video cups${NC}'\n"
	else
		printf "on screen, and remember to invite yourself to the '${CYAN}wheel video${NC}'\n"
	fi
	printf "groups and give yourself a proper ${YELLOW}password${NC}!\n"
	printf "The installer also assumes your home folder is located in ${CYAN}/home${NC}.\n\n"

	if [ "$INST_Office" -eq 1 ] ; then
		groupadd cups
	fi

	if adduser ; then
		echo ""	# continue
	else
		printf "[ ${RED}ERROR${NC} ]  User creation failed!\n"
		exit 1
	fi
}

s_skel
s_user

# ----------------------------------------------------------------------
# ------------------------------------ installation
# ----------------------------------------------------------------------

# ------------------------------------ base

i_patches () {
	if [ "$FBSD_UPD" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Applying latest FreeBSD security patches\n\n"
		freebsd-update fetch install
		echo ""
	else
		printf "[ ${YELLOW}NOTE${NC} ]  Skipping FreeBSD security patches\n"
	fi
}

i_pkg () {
	if [ "$INST_PKG" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Bootstrapping PKG\n\n"
		env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg
		echo ""
	else
		printf "[ ${YELLOW}NOTE${NC} ]  Skipping PKG bootstrap\n"
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
		printf "[ ${RED}ERROR${NC} ]  PKG update failed\n"
		exit 1
	fi
}

i_xorg () {
	if [ "$INST_XORG" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing XORG\n\n"
		pkg install -y xorg
		echo ""
		
		pkg install -y urwfonts
		echo ""

		pkg install -y mesa-demos
		echo ""
	fi
}

i_patches
i_pkg
i_xorg

# ------------------------------------ MATE

i_mate () {
	printf "[ ${GREEN}NOTE${NC} ]  Installing MATE Desktop\n\n"
	pkg install -y mate
	echo ""
	
	printf "[ ${GREEN}NOTE${NC} ]  Installing Brisk Menu\n\n"
	pkg install -y brisk-menu
	echo ""

	printf "[ ${GREEN}NOTE${NC} ]  Installing Arc Themes\n\n"
	pkg install -y gtk-arc-themes
	echo ""
	
	printf "[ ${GREEN}NOTE${NC} ]  Installing Arc Dark Grey\n\n"
	cd /tmp
	if fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/themes/Arc-Dark-Grey.tar.xz ; then
		tar xf Arc-Dark-Grey.tar.xz -C /usr/local/share/themes
		chmod -R 755 /usr/local/share/themes/Arc-Dark-Grey
		rm Arc-Dark-Grey.tar.xz
	fi
	echo ""
	
	printf "[ ${GREEN}NOTE${NC} ]  Installing Papirus icons\n\n"
	pkg install -y papirus-icon-theme
	echo ""

	printf "[ ${GREEN}NOTE${NC} ]  Adding PolicyKit rules\n\n"	
	cd /usr/local/share/polkit-1/rules.d
	fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/polkit/shutdown-reboot.rules
	chmod 755 shutdown-reboot.rules
	cd /tmp
	echo ""
}

s_procfs () {
	printf "[ ${GREEN}NOTE${NC} ]  Declaring procfs in /etc/fstab\n\n"
	if grep -q procfs /etc/fstab ; then
		printf "procfs entry already exists\n\n"
	else
		echo "proc		/proc	procfs	rw	0	0" >> /etc/fstab
	fi
}

s_tmpfs () {
	printf "[ ${GREEN}NOTE${NC} ]  Declaring tmpfs in /etc/fstab\n\n"
	if grep -q procfs /etc/fstab ; then
		printf "tmpfs entry already exists\n\n"
	else
		mkdir /tmpfs && chmod 777 /tmpfs && ln -s /tmpfs /usr/share/skel/tmpfs && echo "tmpfs		/tmpfs		tmpfs	rw	0	0" >> /etc/fstab
	fi	
}

i_slim () {
	printf "[ ${GREEN}NOTE${NC} ]  Installing SLiM\n\n"
	pkg install -y slim
	echo ""
	
	mkdir -p /etc/X11/xorg.conf.d
	chmod 755 /etc/X11/xorg.conf.d
	touch /etc/X11/xorg.conf.d/10-keyboard.conf
	chmod 755 /etc/X11/xorg.conf.d/10-keyboard.conf
	echo "# keyboard layout for SLiM (Login Manager)
Section \"InputClass\"
	Identifier \"Keyboard0\"
	MatchIsKeyboard \"on\"
	Option \"XkbModel\" \"pc105\"
	Option \"XkbLayout\" \"${KBD_LANG}\"" > /etc/X11/xorg.conf.d/10-keyboard.conf
	if [ -z "$KBD_VAR" ] ; then 
		echo "#	Option \"XkbVariant\" \"\"" >> /etc/X11/xorg.conf.d/10-keyboard.conf
	else
		echo "	Option \"XkbVariant\" \"${KBD_VAR}\"" >> /etc/X11/xorg.conf.d/10-keyboard.conf
	fi
	echo "EndSection
	" >> /etc/X11/xorg.conf.d/10-keyboard.conf
}

t_slim () {
	printf "[ ${GREEN}NOTE${NC} ]  Installing SLiM theme\n\n"
	cd /tmp
	if fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/themes/darkslim.tar.xz ; then
		tar xf darkslim.tar.xz -C /usr/local/share/slim/themes
		sed -i ".bak" "s/current_theme.*/current_theme		darkslim/" /usr/local/etc/slim.conf
		rm darkslim.tar.xz
	fi
	echo ""
}

s_rcconf () {
	printf "[ ${GREEN}NOTE${NC} ]  Configuring rc.conf\n\n"
	cp /etc/rc.conf /etc/rc.conf.bak
	sysrc moused_enable="YES"
	sysrc dbus_enable="YES"
	sysrc slim_enable="YES"

	# HALD is Deprecated
	if grep -q hald_enable /etc/rc.conf ; then
		echo "" # assume there is a reason why it's already here
	else
		echo "# hald_enable=\"YES\" ### DEPRECATED" >> /etc/rc.conf
	fi

	if [ "$INST_Office" -eq 1 ] ; then
		sysrc cupsd_enable="YES"
	fi
}

t_mate () {
	printf "[ ${GREEN}NOTE${NC} ]  Installing MATE theme\n\n"
	mkdir -p /usr/local/share/backgrounds/fbsd
	chown root:wheel /usr/local/share/backgrounds/fbsd
	chmod 775 /usr/local/share/backgrounds/fbsd
	
	cd /usr/local/share/backgrounds/fbsd
	fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/wallpaper/centerFlat_grey-1080.png
	chmod 775 centerFlat_grey-1080.png
	fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/wallpaper/centerFlat_grey-4k.png
	chmod 775 centerFlat_grey-4k.png
	fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/wallpaper/centerFlat_red-1080.png
	chmod 775 centerFlat_red-1080.png
	fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/wallpaper/centerFlat_red-4k.png
	chmod 775 centerFlat_red-4k.png
	
	mkdir -p /usr/local/etc/dconf/profile
	cd /usr/local/etc/dconf/profile
	echo "user-db:user
system-db:mate
" > user
	chmod 755 user
	
	cd /tmp
	if fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/themes/darkmate-settings ; then
		chmod 775 darkmate-settings
		if [ -z "$KBD_VAR" ] ; then
			sed -i ".bak" "s/#####KBD/layouts=['${KBD_LANG}']/" darkmate-settings
		else
			sed -i ".bak" "s/#####KBD/layouts=['${KBD_LANG}\t${KBD_VAR}']/" darkmate-settings
		fi
		
		mkdir -p /usr/local/etc/dconf/db/mate.d
		mv darkmate-settings /usr/local/etc/dconf/db/mate.d
		
		dconf update
	fi
	
	echo ""
}

if [ "$INST_MATE" -eq 1 ] ; then
	i_mate		# install MATE & related pkgs
	s_procfs	# setup procfs
	s_tmpfs		# setup tmpfs
	i_slim		# install SLiM pkg
	t_slim		# theme SLiM
	s_rcconf	# modifying rc.conf
	t_mate		# theme mate
fi

# ------------------------------------ user selected software

i_firefox () {
	if [ "$INST_Firefox" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing Firefox Browser\n\n"
		pkg install -y firefox
		echo ""
	fi
}
i_firefox

i_chrome () {
	if [ "$INST_Chromium" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing Chromium Browser\n\n"
		pkg install -y chromium
		if grep -q kern.ipc.shm_allow_removed /etc/sysctl.conf ; then
			sed -i ".bak" "s/kern.ipc.shm_allow_removed.*/kern.ipc.shm_allow_removed=1/" /etc/sysctl.conf
		else
			echo "
# ---- for Chromium browser
kern.ipc.shm_allow_removed=1" >> /etc/sysctl.conf
		fi
		echo ""
	fi
}
i_chrome

i_mail () {
	if [ "$INST_Thunderbird" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing Thunderbird\n\n"
		pkg install -y thunderbird
		echo ""
		pkg install -y thunderbird-dictionaries
		echo ""
	fi
}
i_mail

i_vlc () {
	if [ "$INST_VLC" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing VLC Media Player\n\n"
		pkg install -y vlc
		echo ""
	fi
}
i_vlc

i_office () {
	if [ "$INST_Office" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing LibreOffice\n\n"
		pkg install -y libreoffice
		echo ""
		
		printf "[ ${GREEN}NOTE${NC} ]  Installing Xsane\n\n"
		pkg install -y xsane
		echo ""

		printf "[ ${GREEN}NOTE${NC} ]  Installing CUPS\n\n"
		pkg install -y cups
		echo ""
		pkg install -y cups-pdf
		echo ""
		pkg install -y gutenprint
		echo ""
	fi
}
i_office

i_cpp () {
	if [ "$INST_CPP" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing CodeLite IDE\n\n"
		pkg install -y codelite
		echo ""
	fi
}
i_cpp

i_java () {
	if [ "$INST_Java" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing Netbeans IDE\n\n"
		pkg install -y netbeans
		cd /usr/local/netbeans*/etc
		sed -i ".bak" 's/.*netbeans_jdkhome.*/netbeans_jdkhome=\"\/usr\/local\/openjdk8\"/' netbeans.conf
		echo ""
	fi
}
i_java

# ------------------------------------ automatically selected software

i_tools () {
	printf "[ ${GREEN}NOTE${NC} ]  Installing additional tools\n\n----- NANO\n"
	pkg install -y nano
	
	echo ""
	echo "----- VIM"
	pkg install -y vim

	echo ""
	echo "----- UNAR"
	pkg install -y unar

	echo ""
	echo "----- SYSINFO"
	pkg install -y sysinfo

	echo ""
	echo "----- HTOP"
	pkg install -y htop

	cd /usr/local/bin
	echo ""
	echo "----- INXI"
	fetch --no-verify-peer https://raw.githubusercontent.com/smxi/inxi/master/inxi
	chmod 755 inxi
	#echo "
#----- custom"
	#fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/tools/cputemp.sh
	#chmod 755 cputemp.sh
	#fetch --no-verify-peer https://raw.githubusercontent.com/broozar/installDesktopFreeBSD/DarkMate12.1/files/tools/dumpMate.sh
	#chmod 755 dumpMate.sh
	
	if [ "$INST_XORG" -eq 1 ] ; then
		echo ""
		echo "----- GEANY"
		pkg install -y geany
	fi
	
	echo ""
}
i_tools

# ------------------------------------ drivers and boot

i_nvidia () {
	if [ "$INST_NVIDIA" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing NVIDIA (current)\n\n"
		pkg install -y nvidia-driver
		echo ""
		pkg install -y nvidia-xconfig
		echo ""
		pkg install -y nvidia-settings
		echo ""
		
		# run autoconfig
		nvidia-xconfig
		echo ""

	elif [ "$INST_LEGVIDIA" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing NVIDIA (legacy)\n\n"
		pkg install -y nvidia-driver-390
		echo ""
	
	elif [ "$INST_OLDVIDIA" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing NVIDIA (old)\n\n"
		pkg install -y nvidia-driver-340
		echo ""
	
	elif [ "$INST_DEADVIDIA" -eq 1 ] ; then
		printf "[ ${GREEN}NOTE${NC} ]  Installing NVIDIA (ancient)\n\n"
		pkg install -y nvidia-driver-304
		echo ""
	fi
	
	# modify rc.conf for nvidia drivers
	
	if [ "$INST_NVIDIA" -eq 1 -o "$INST_LEGVIDIA" -eq 1 ] ; then
		sysrc kld_list+="nvidia-modeset"
		sysrc kld_list+="nvidia"
				
	elif [ "$INST_OLDVIDIA" -eq 1 -o "$INST_DEADVIDIA" -eq 1 ] ; then
		sysrc kld_list+="nvidia"
	fi	
}
i_nvidia

s_bootconf () {
	printf "[ ${GREEN}NOTE${NC} ]  Configuring boot/loader.conf\n\n"
	if grep -q coretemp_load /boot/loader.conf ; then
		sed -i ".bak" "s/coretemp_load.*/coretemp_load=\"YES\"/" /boot/loader.conf
	else
		echo "coretemp_load=\"YES\"" >> /boot/loader.conf
	fi
}
s_bootconf

i_final () {
	printf "[ ${GREEN}NOTE${NC} ]  Time for a final update check!\n\n"
	pkg upgrade -y
	echo ""

	printf "[ ${YELLOW}NOTE${NC} ]  Installation complete. Please restart your system!\n"
	printf "Either type ${CYAN}shutdown -r now${NC} to reboot now, or manually add\n"
	printf "other applications with ${CYAN}pkg install §name${NC} and reboot later.\n\n"
}
i_final

# EOF



# ------------------------------------ scratchpad - TODO

# --- anyone up for semi-automatic GPU detection and driver installation beyond Nvidia?
