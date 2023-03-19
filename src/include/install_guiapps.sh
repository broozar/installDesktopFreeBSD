# ------------------------------------ selected apps

if [ "$INST_Firefox" -eq 1 ] ; then
	_pih firefox-esr "Firefox Browser"
fi

if [ "$INST_Chromium" -eq 1 ] ; then
	_pih chromium "Chromium Browser"
	if grep -q kern.ipc.shm_allow_removed /etc/sysctl.conf ; then
		sed -i ".bak" "s/kern.ipc.shm_allow_removed.*/kern.ipc.shm_allow_removed=1/" /etc/sysctl.conf
	else
		echo "
# ---- for Chromium browser
kern.ipc.shm_allow_removed=1" >> /etc/sysctl.conf
	fi
	echo ""
fi

if [ "$INST_Thunderbird" -eq 1 ] ; then
	_pih thunderbird "Tunderbird mail"
	_pi thunderbird-dictionaries
fi

if [ "$INST_VLC" -eq 1 ] ; then
	_pih vlc "VLC Media Player"
	_pih youtube_dl "Youtube-DL"
fi

if [ "$INST_Office" -eq 1 ] ; then
	_pih libreoffice "LibreOffice"

	groupadd cups
	$USERGROUPS="${USERGROUPS},cups"

	_pi xsane
	_pi cups
	_pi cups-pdf
	_pi gutenprint
	
	sysrc cupsd_enable="YES"
fi

if [ "$INST_CPP" -eq 1 ] ; then
	_pih codelite "CodeLite IDE"
	_pi cloc
fi

if [ "$INST_Java" -eq 1 ] ; then
	_pih netbeans "Netbeans IDE"
	cd /usr/local/netbeans*/etc
	sed -i ".bak" 's/.*netbeans_jdkhome.*/netbeans_jdkhome=\"\/usr\/local\/openjdk8\"/' netbeans.conf
	
	_pi cloc
fi


# ------------------------------------ default apps

_pi geany
