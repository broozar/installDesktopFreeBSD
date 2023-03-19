# ------------------------------------ dialog factories

# yesno dialog
# $1 question, $2 title
_dn () {
	dialog --clear --title "$2" --backtitle "$DIA_BACKTITLE" --yesno "$1" $DIA_MSG_HEIGHT $DIA_MSG_WIDTH
	if [ $? -eq 0 ] ; then
		return 1
	else
		return 0
	fi
}

# radio selection with dialog
# $1 question, $2 title
_dr () {
	DIA_RESULT=''
	DIA_RESULT=$(dialog --clear --title "$2" --backtitle "$DIA_BACKTITLE" --radiolist "$1" $DIA_OPT_HEIGHT $DIA_OPT_WIDTH $DIA_CHOICE_HEIGHT $DIA_OPTIONS 2>&1 > /dev/tty)
}

# checklist selection with dialog
# $1 question, $2 title
_dc () {
	DIA_RESULT=''
	DIA_RESULT=$(dialog --clear --title "$2" --backtitle "$DIA_BACKTITLE" --checklist "$1" $DIA_OPT_HEIGHT $DIA_OPT_WIDTH $DIA_CHOICE_HEIGHT $DIA_OPTIONS 2>&1 > /dev/tty)
}

# menu selection with dialog
# $1 question, $2 title
_dm () {
	DIA_RESULT=''
	DIA_RESULT=$(dialog --clear --title "$2" --backtitle "$DIA_BACKTITLE" --menu "$1" $DIA_OPT_HEIGHT $DIA_OPT_WIDTH $DIA_CHOICE_HEIGHT $DIA_OPTIONS 2>&1 > /dev/tty)
}

# form input with dialog
# $1 question, $2 title
_df () {
	DIA_RESULT=''
	DIA_RESULT=$(dialog --clear --ok-label "Submit" --title "$2" --backtitle "$DIA_BACKTITLE" --form "$1" $DIA_OPT_HEIGHT $DIA_OPT_WIDTH $DIA_CHOICE_HEIGHT $DIA_OPTIONS 2>&1 > /dev/tty)
}


# ------------------------------------ mirror location

_dmirror () {
		DIA_OPTIONS="1 Automatic
		2 EU
        3 US-East
        4 US-West"
	
	_dm "Please select your nearest download server:" "PKG Mirror"
	case $DIA_RESULT in
		2) MIRR_PKG='eu.' ;;
		3) MIRR_PKG='us-east.' ;;
		4) MIRR_PKG='us-west.' ;;
		*) MIRR_PKG='' ;;
	esac
}


# ------------------------------------ keymap selection

_dkbd () {
	DIA_OPTIONS="$DIA_KBD_LANG"
	_dm "Please select your keyboard layout:" "Keyboard Layout"
	if [ -z $DIA_RESULT ] ; then
		_abortmsg "Keymap selection is required."
	fi
	KBD_LANG="$DIA_RESULT"

	# only display variants if there are any
	DIA_OPTIONS=$(eval "echo \$DIA_KBD_VAR_${KBD_LANG}")
	if [ ! -z "$DIA_OPTIONS" ] ; then
		_dn "Would you like to add a special variant of your keyboard (e.g. dvorak, nodeadkeys etc.)?" "Keyboard Variant"
		if [ $? -eq 1 ] ; then
			_dm "Please select your keyboard variant:" "Keyboard Variant"
			KBD_VAR="$DIA_RESULT"
		fi
	fi
}


# ------------------------------------ GUI software selection

_dxsoft () {
	DIA_OPTIONS="1 Firefox on
        2 Chromium on
        3 Thunderbird off
        4 Libreoffice/SANE/CUPS off
        5 VLC on
        6 CodeLite/C++ on
        7 Netbeans/Java off"
	
	_dc "Please choose your X applications (space bar):" "Application Selection"
	case $DIA_RESULT in *1*) INST_Firefox=1 ;; esac
	case $DIA_RESULT in *2*) INST_Chromium=1 ;; esac
	case $DIA_RESULT in *3*) INST_Thunderbird=1 ;; esac
	case $DIA_RESULT in *4*) INST_Office=1 ;; esac
	case $DIA_RESULT in *5*) INST_VLC=1 ;; esac
	case $DIA_RESULT in *6*) INST_CPP=1 ;; esac
	case $DIA_RESULT in *7*) INST_Java=1 ;; esac
	# TODO: Cancel button should exit script
}


# ------------------------------------ CLI software selection

_dcsoft () {
	DIA_OPTIONS="1 Apache/MariaDB/PHP on
        2 Sytem-tools on
		3 Emacs off"
	
	_dc "Please choose your console applications (space bar):" "Application Selection"
	case $DIA_RESULT in *1*) INST_FAMP=1 ;; esac
	case $DIA_RESULT in *2*) INST_SYSTOOLS=1 ;; esac
	case $DIA_RESULT in *3*) INST_EMACS=1 ;; esac
	# TODO: Cancel button should exit script
}


# ------------------------------------ DE selection

_dde () {
	DIA_OPTIONS="1 MATE
        2 Cinnamon"
	
	_dm "Please choose your desktop environment:" "Desktop Selection"
	case $DIA_RESULT in
		1) INST_MATE=1 ;;
		2) INST_CINNAMON=1 ;;
		*) _abortmsg "Desktop environment selection is required." ;;
	esac
}


# ------------------------------------ video driver

_dvselect () {
	DIA_OPTIONS="1 nVidia
				2 AMD/ATI
				3 Intel
				4 KMOD
				5 Fallback/VESA"

	_dm "Please select your graphics vendor:" "Video driver"
	case $DIA_RESULT in
		1) _dvgen_nv ;;
		2) _dvgen_amd ;;
		3) _dvgen_intel ;;
		4) _dvgen_kmod ;;
		5) ;;
		*) _abort;;
	esac
}

_dvgen_nv () {
	DIA_OPTIONS="1 nVidia_current
				2 nVidia_last_v470
				3 nVidia_legacy_v390
				4 nVidia_old_v340
				5 nVidia_ancient_304"

	_dm "Please select your nVidia driver:" "Video driver"
	case $DIA_RESULT in
		1) INST_VIDEO_NVIDIA_CUR=1 ;;
		2) INST_VIDEO_NVIDIA_470=1 ;;
		3) INST_VIDEO_NVIDIA_390=1 ;;
		4) INST_VIDEO_NVIDIA_340=1 ;;
		5) INST_VIDEO_NVIDIA_304=1 ;;
		*) _dvselect;;
	esac
}

_dvgen_amd () {
	DIA_OPTIONS="1 AMDGPU_current
				2 RADEON/ATI_old"

	_dm "Please select your AMD/ATI driver:" "Video driver"
	case $DIA_RESULT in
		1) INST_VIDEO_AMDGPU=1 ;;
		2) INST_VIDEO_RADEON=1 ;;
		*) _dvselect;;
	esac
}

_dvgen_intel () {
	DIA_OPTIONS="1 Intel_current_SandyBridge+
				2 Intel_older"

	_dm "Please select your Intel driver:" "Video driver"
	case $DIA_RESULT in
		1) INST_VIDEO_INTEL_CURRENT=1 ;;
		2) INST_VIDEO_INTEL_LEGACY=1 ;;
		*) _dvselect;;
	esac
}

_dvgen_kmod () {
	DIA_OPTIONS="1 KMOD_AMDGPU_current
				2 KMOD_RADEON_old
				3 KMOD_INTEL"

	_dm "Please select your KMOD driver:" "Video driver"
	case $DIA_RESULT in
		1) INST_VIDEO_KMOD_AMDGPU=1 ;;
		2) INST_VIDEO_KMOD_RADEON=1 ;;
		3) INST_VIDEO_KMOD_INTEL=1 ;;
		*) _dvselect;;
	esac
}


# ------------------------------------ login

_dlogin () {
	DIA_OPTIONS="1 SLiM
				2 LightDM
				3 none/terminal"
	
	_dm "Please select a login manager:" "Login Manager"
	case $DIA_RESULT in
		1) INST_SLIM=1 ;;
		2) INST_LIGHTDM=1 ;;
		3) ;;
		*) _abort;;
	esac
}


# ------------------------------------ user account creation

_duser () {
	DIA_OPTIONS="Username: 1 1 username 1 11 15 0
	Password: 2 1 pass1234 2 11 15 0
	UID: 3 1 auto 3 11 15 0
	GID: 4 1 auto 4 11 15 0
	HomeDir: 5 1 auto 5 11 15 0"
	
	_df "Enter data for a new user. You can leave UID, GID and HOMEDIR (/home/...) on auto if you wish to use the defaults." "User Accounts"
	_daccount $DIA_RESULT
}

# $1 username $2 password $3 uid $4 gid $5 home
_daccount () {
	if [ "$#" -ne 5 ] ; then
		_dn "Input error. Try again?" "User Accounts"
		if [ $? -eq 1 ] ; then
			_duser
			return 0
		else
			_abortmsg "User creation failed."
		fi
	fi
	
	if [ "$5" = "auto" ] ; then
		echo "$2" | pw user add -n "$1" -c "$1" -G "$USERGROUPS" -m -h 0
		if [ ! -d "/home/$1" ] ; then
			_dn "User account creation failed. Try again?" "User Accounts"
			if [ $? -eq 1 ] ; then
				_duser
				return 0
			else
				_abortmsg "User creation failed."
			fi
		fi
		
	else
		echo "$2" | pw user add -n "$1" -G "$USERGROUPS" -m -d "$5" -h 0
		if [ ! -d "$5" ] ; then
			_dn "User account creation failed. Try again?" "User Accounts"
			if [ $? -eq 1 ] ; then
				_duser
				return 0
			else
				_abortmsg "User creation failed."
			fi
		fi
	fi	
	
	if [ "$3" != "auto" ] ; then
		pw user mod -n "$1" -u "$3"
		if [ ! $? ] ; then
			_dn "UID modification failed. Try again?" "User Accounts"
			if [ $? -eq 1 ] ; then
				_duser
				return 0
			else
				_abortmsg "User creation failed."
			fi
		fi
	fi
	
	if [ "$4" != "auto" ] ; then
		pw user mod -n "$1" -g "$4"
		if [ ! $? ] ; then
			_dn "GID modification failed. Try again?" "User Accounts"
			if [ $? -eq 1 ] ; then
				_duser
				return 0
			else
				_abortmsg "User creation failed."
			fi
		fi
	fi
	
	_dn "User account creation was successful. Create another user?" "User Accounts"
	if [ $? -eq 1 ] ; then
		_duser
		return 0
	fi
}