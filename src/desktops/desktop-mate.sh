# ------------------------------------ install

_pih xorg "XORG"
_pi urwfonts
_pi hack-font
_pi mesa-demos
	
_pih mate "MATE Desktop"
_pih brisk-menu "Brisk Menu"
_pih papirus-icon-theme "Papirus icons"
_pih gtk-arc-themes "Arc Themes"

# prepackaged designs
printf "[ ${CG}NOTE${NC} ]  Installing Minty themes\n\n"
tar xf ${CWD}/themes/Arc-Dark-Grey.tar.xz -C /usr/local/share/themes
chmod -R 755 /usr/local/share/themes/Arc-Dark-Grey

tar xf ${CWD}/themes/Mint-Y-Dark-Aqua.zip -C /usr/local/share/themes
chmod -R 755 /usr/local/share/themes/Mint-Y-Dark-Aqua

tar xf ${CWD}/themes/Mint-Y-Dark-Grey.zip -C /usr/local/share/themes
chmod -R 755 /usr/local/share/themes/Mint-Y-Dark-Grey

tar xf ${CWD}/themes/Mint-Y-Dark-Red.zip -C /usr/local/share/themes
chmod -R 755 /usr/local/share/themes/Mint-Y-Dark-Red

tar xf ${CWD}/themes/Mint-Y-Dark-Teal.zip -C /usr/local/share/themes
chmod -R 755 /usr/local/share/themes/Mint-Y-Dark-Teal
echo ""

# custom art
. ${CWD}/desktops/wallpapers.sh

# policy
printf "[ ${CG}NOTE${NC} ]  Adding PolicyKit rules\n\n"	
cp ${CWD}/polkit/shutdown-reboot.rules /usr/local/share/polkit-1/rules.d
chmod 755 /usr/local/share/polkit-1/rules.d/shutdown-reboot.rules
echo ""

printf "[ ${CG}NOTE${NC} ]  Mate dumpsettings tool\n\n"	
cp ${CWD}/tools/mate-dumpsettings /usr/local/bin
chmod 755 /usr/local/bin/mate-dumpsettings
echo ""


# ------------------------------------ configure

printf "[ ${CG}NOTE${NC} ]  Declaring procfs in /etc/fstab\n\n"
if grep -q procfs /etc/fstab ; then
	printf "procfs entry already exists\n\n"
else
	echo "proc		/proc	procfs	rw	0	0" >> /etc/fstab
fi
echo ""

printf "[ ${CG}NOTE${NC} ]  Configuring rc.conf\n\n"
sysrc moused_enable="NO"	# fix mouse scrolling conflict in MATE
sysrc dbus_enable="YES"
sysrc hald_enable="YES"		# DEPRECATED
echo ""

printf "[ ${CG}NOTE${NC} ]  Installing MATE theme settings\n\n"
mkdir -p /usr/local/etc/dconf/profile
echo "user-db:user
system-db:mate
" > /usr/local/etc/dconf/profile/user
chmod 755 /usr/local/etc/dconf/profile/user

if [ -z "$KBD_VAR" ] ; then
	sed -i ".bak" "s/#####KBD/layouts=['${KBD_LANG}']/" ${CWD}/config/darkmate-settings
else
	sed -i ".bak" "s/#####KBD/layouts=['${KBD_LANG}\\\t${KBD_VAR}']/" ${CWD}/config/darkmate-settings
fi
mkdir -p /usr/local/etc/dconf/db/mate.d
cp ${CWD}/config/darkmate-settings /usr/local/etc/dconf/db/mate.d
chmod 775 /usr/local/etc/dconf/db/mate.d/darkmate-settings
dconf update
echo ""
