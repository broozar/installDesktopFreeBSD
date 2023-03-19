mkdir -p /etc/X11/xorg.conf.d
chmod 755 /etc/X11/xorg.conf.d
cp ${CWD}/config/10-keyboard.conf /etc/X11/xorg.conf.d/
chmod 755 /etc/X11/xorg.conf.d/10-keyboard.conf

if [ -z "$KBD_VAR" ] ; then
	sed -i ".bak" "s/#####KBD/Option \"XkbLayout\" \"${KBD_LANG}\"/" /etc/X11/xorg.conf.d/10-keyboard.conf
else
	sed -i ".bak" "s/#####KBD/Option \"XkbLayout\" \"${KBD_LANG}\"\n\tOption \"XkbVariant\" \"${KBD_VAR}\"/" /etc/X11/xorg.conf.d/10-keyboard.conf
fi

echo ""