# ------------------------------------ nVidia

if [ "$INST_VIDEO_NVIDIA_CUR" -eq 1 ] ; then
	_pih nvidia-driver "NVIDIA driver (current)"
	_pi nvidia-xconfig
	_pi nvidia-settings
	
	# run autoconfig
	nvidia-xconfig
	echo ""
	sysrc kld_list+="nvidia-modeset"
	sysrc kld_list+="nvidia"

elif [ "$INST_VIDEO_NVIDIA_470" -eq 1 ] ; then
	_pih nvidia-driver-470 "NVIDIA driver (last)"
	sysrc kld_list+="nvidia-modeset"
	sysrc kld_list+="nvidia"

elif [ "$INST_VIDEO_NVIDIA_390" -eq 1 ] ; then
	_pih nvidia-driver-390 "NVIDIA driver (legacy)"
	sysrc kld_list+="nvidia-modeset"
	sysrc kld_list+="nvidia"

elif [ "$INST_VIDEO_NVIDIA_340" -eq 1 ] ; then
	_pih nvidia-driver-340 "NVIDIA driver (old)"
	sysrc kld_list+="nvidia"

elif [ "$INST_VIDEO_NVIDIA_304" -eq 1 ] ; then
	_pih nvidia-driver-304 "NVIDIA driver (ancient)"
	sysrc kld_list+="nvidia"


# ------------------------------------ amd/ati

elif [ "$INST_VIDEO_AMDGPU" -eq 1 ] ; then
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="amdgpu"
	_pih xf86-video-amdgpu "AMDGPU (current)"

	cp ${CWD}/config/20-amdgpu.conf /etc/X11/xorg.conf.d/
	chmod 755 /etc/X11/xorg.conf.d/20-amdgpu.conf
	echo ""

elif [ "$INST_VIDEO_RADEON" -eq 1 ] ; then
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="radeonkms"
	_pih xf86-video-ati "RADEON (legacy)"

	cp ${CWD}/config/20-radeon.conf /etc/X11/xorg.conf.d/
	chmod 755 /etc/X11/xorg.conf.d/20-radeon.conf
	echo ""

elif [ "$INST_VIDEO_RADEONHD" -eq 1 ] ; then
	printf "[ ${CY}NOTE${NC} ]  RADEONHD driver is not supported\n"
	echo ""


# ------------------------------------ intel

elif [ "$INST_VIDEO_INTEL_CURRENT" -eq 1 ] ; then
	# TODO - untested
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="i915kms"
	_pih xf86-video-intel "INTEL graphics (current)"

	cp ${CWD}/config/20-intelSB.conf /etc/X11/xorg.conf.d/
	chmod 755 /etc/X11/xorg.conf.d/20-intelSB.conf
	echo ""

elif [ "$INST_VIDEO_INTEL_LEGACY" -eq 1 ] ; then
	# TODO - untested
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="i915kms"
	_pih xf86-video-intel "INTEL graphics (legacy)"

	cp ${CWD}/config/20-intel.conf /etc/X11/xorg.conf.d/
	chmod 755 /etc/X11/xorg.conf.d/20-intel.conf
	echo ""


# ------------------------------------ kmod only

elif [ "$INST_VIDEO_KMOD_AMDGPU" -eq 1 ] ; then
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="amdgpu"

elif [ "$INST_VIDEO_KMOD_RADEON" -eq 1 ] ; then
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="radeonkms"

elif [ "$INST_VIDEO_KMOD_INTEL" -eq 1 ] ; then
	_pih drm-kmod "DRM-KMOD driver"	
	sysrc kld_list+="i915kms"
	
fi
