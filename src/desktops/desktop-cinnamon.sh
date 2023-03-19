# ------------------------------------ install

_pih xorg "XORG"
_pi urwfonts
_pi hack-font
_pi mesa-demos
	
_pih cinnamon "Cinnamon Desktop"
_pih papirus-icon-theme "Papirus icons"

_pi libadwaita
_pi adwaita-icon-theme
_pi gnome-terminal
_pi xarchive

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
. ${CWD}/desktops/icons.sh


printf "[ ${CG}NOTE${NC} ]  Cinnamon dumpsettings tool\n\n"	
cp ${CWD}/tools/cinnamon-dumpsettings /usr/local/bin
chmod 755 /usr/local/bin/cinnamon-dumpsettings
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
sysrc moused_enable="NO"	# fix mouse scrolling conflict
sysrc dbus_enable="YES"
sysrc hald_enable="YES"		# DEPRECATED
echo ""


printf "[ ${CG}NOTE${NC} ]  Installing Cinnamon theme settings\n\n"
mkdir -p /usr/local/etc/dconf/profile

echo "user-db:user
system-db:cinnamon
" > /usr/local/etc/dconf/profile/user
chmod 755 /usr/local/etc/dconf/profile/user

mkdir -p /usr/local/etc/dconf/db/cinnamon.d
cp ${CWD}/config/cinnamon-settings /usr/local/etc/dconf/db/cinnamon.d
cp ${CWD}/config/nemo-settings /usr/local/etc/dconf/db/cinnamon.d
cp ${CWD}/config/gterm-settings /usr/local/etc/dconf/db/cinnamon.d
chmod 775 /usr/local/etc/dconf/db/cinnamon.d/cinnamon-settings
chmod 775 /usr/local/etc/dconf/db/cinnamon.d/nemo-settings
chmod 775 /usr/local/etc/dconf/db/cinnamon.d/gterm-settings

TID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
sed -i ".bak" "s/#####TERM/${TID}/" /usr/local/etc/dconf/db/cinnamon.d/gterm-settings

dconf update
echo ""
