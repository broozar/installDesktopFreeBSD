# ------------------------------------ PKG

INST_PKG=1			# assume a fresh install
MIRR_PKG=''			# mirrors for PKG: * "", 2 "eu.", 3 "us-east.", 4 "us-west."
FBSD_UPD=0			# fetch security patches only if requested


# ------------------------------------ DESKTOPS

INST_MATE=0			# nice desktop environment
INST_CINNAMON=0		# even nicer desktop environment


# ------------------------------------ LOGIN

INST_SLIM=0			# simple but abandoned login manager
INST_LIGHTDM=0		# modern light-weight login manager


# ------------------------------------ KEYBOARD

KBD_LANG='us'		# keyboard layout (language)
KBD_VAR=''			# keyboard layout (variant)


# ------------------------------------ GUI APPS

INST_Firefox=0		# free browser
INST_Chromium=0		# google browser
INST_Thunderbird=0	# mail client
INST_Office=0		# libreoffice
INST_VLC=0			# media playback
INST_CPP=0			# C++ and IDE
INST_Java=0			# Java and IDE


# ------------------------------------ CLI APPS

INST_SYSTOOLS=0		# Htop etc.
INST_FAMP=0			# Apache/PHP/MySQL
INST_EMACS=0		# Emacs


# ------------------------------------ VIDEO

INST_VIDEO_NVIDIA_CUR=0			# current NVIDIA driver
INST_VIDEO_NVIDIA_470=0			# last NVIDIA driver
INST_VIDEO_NVIDIA_390=0			# legacy NVIDIA driver
INST_VIDEO_NVIDIA_340=0			# even older NVIDIA driver
INST_VIDEO_NVIDIA_304=0			# decade old NVIDIA driver
INST_VIDEO_AMDGPU=0				# modern AMD video driver
INST_VIDEO_RADEON=0				# alternative AMD video driver
INST_VIDEO_RADEONHD=0			# another alternative AMD video driver # UNUSED
INST_VIDEO_INTEL_CURRENT=0		# Intel video driver >Sandy Bridge
INST_VIDEO_INTEL_LEGACY=0		# Intel video driver <Sandy Bridge
INST_VIDEO_KMOD_AMDGPU=0		# kmod driver - AMDGPU module
INST_VIDEO_KMOD_RADEON=0		# kmod driver - RADEON module
INST_VIDEO_KMOD_INTEL=0			# kmod driver - INTEL module


# ------------------------------------ USERS

USERGROUPS="wheel,video"		# default groups for new users. CUPS added later if office is installed
