printf "[ ${CG}NOTE${NC} ]  Installing FreeBSDesktop wallpapers\n\n"
mkdir -p /usr/local/share/backgrounds/freebsdesktop
chown root:wheel /usr/local/share/backgrounds/freebsdesktop

cp ${CWD}/themes/wallpaper/* /usr/local/share/backgrounds/freebsdesktop

chmod -R 775 /usr/local/share/backgrounds/freebsdesktop
echo ""