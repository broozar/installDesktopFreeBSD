_pih slim "SLiM login manager"
sysrc slim_enable="YES"

printf "[ ${CG}NOTE${NC} ]  Installing SLiM theme\n\n"
tar xf ${CWD}/themes/darkslim.tar.xz -C /usr/local/share/slim/themes
sed -i ".bak" "s/current_theme.*/current_theme		darkslim/" /usr/local/etc/slim.conf
