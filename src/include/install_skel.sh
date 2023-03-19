# definitions of the default folder structure in new user accounts

printf "[ ${CG}NOTE${NC} ]  Creating SKEL structure\n\n"

# home subfolders
mkdir /usr/share/skel/Documents
mkdir /usr/share/skel/Downloads
mkdir /usr/share/skel/Media
mkdir /usr/share/skel/Programming

# core dump location
LOC=/var/coredump
mkdir ${LOC} && chmod 775 ${LOC}
ln -s ${LOC} /usr/share/skel/Programming/
sysctl kern.corefile=${LOC}/%N.core

# separators
mkdir -p /usr/share/skel/dot.config/gtk-3.0
touch /usr/share/skel/dot.config/gtk-3.0/gtk.css
echo "PanelSeparator {
	color: transparent;
}
" > /usr/share/skel/dot.config/gtk-3.0/gtk.css

# start desktop session
if [ "$INST_MATE" -eq 1 ] ; then
	touch /usr/share/skel/dot.xinitrc
	echo "exec mate-session" > /usr/share/skel/dot.xinitrc
elif [ "$INST_CINNAMON" -eq 1 ] ; then
	#cp -R ${CWD}/config/dot.cinnamon /usr/share/skel
	touch /usr/share/skel/dot.xinitrc
	echo "exec cinnamon-session" > /usr/share/skel/dot.xinitrc
fi

# RAMDisk
printf "[ ${CG}NOTE${NC} ]  Declaring tmpfs in /etc/fstab\n\n"
if grep -q tmpfs /etc/fstab ; then
	printf "tmpfs entry already exists\n"
else
	LOC=/ramdisk
	mkdir ${LOC} && chmod 777 ${LOC}
	ln -s ${LOC} /usr/share/skel
	echo "tmpfs		${LOC}		tmpfs	rw	0	0" >> /etc/fstab
fi	
echo ""

# fix for mousewheel
echo "pointer = 1 2 3 4 5 6 7 0 0 0" > /usr/share/skel/dot.xmodmap

# webserver directory
if [ "$INST_FAMP" -eq 1 ] ; then
	ln -s /usr/local/www /usr/share/skel
	#ln -s /usr/local/www/apache24/data /usr/share/skel
fi

# rights
chown -R root:wheel /usr/share/skel
echo ""