printf "[ ${CG}NOTE${NC} ]  Installing FreeBSDesktop icons\n\n"
mkdir -p /usr/local/share/icons/freebsdesktop
chown root:wheel /usr/local/share/icons/freebsdesktop

cp ${CWD}/themes/icons/* /usr/local/share/icons/freebsdesktop

chmod -R 775 /usr/local/share/icons/freebsdesktop
echo ""