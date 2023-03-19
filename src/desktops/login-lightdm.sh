_pih lightdm "LightDM login manager"
_pi lightdm-gtk-greeter
_pi lightdm-gtk-greeter-settings
sysrc lightdm_enable="YES"

mkdir -p /usr/local/etc/lightdm
chmod 755 /usr/local/etc/lightdm
cp ${CWD}/config/lightdm-gtk-greeter.conf /usr/local/etc/lightdm
chmod 775 /usr/local/etc/lightdm/lightdm-gtk-greeter.conf
