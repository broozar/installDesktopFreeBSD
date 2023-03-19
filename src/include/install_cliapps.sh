if [ "$INST_SYSTOOLS" -eq 1 ] ; then
	printf "[ ${CG}NOTE${NC} ]  Installing system tools\n\n"

	# editors
	_pi nano
	_pi vim

	# system info
	_pi sysinfo
	_pi htop
	_pi neofetch
	_pi inxi

	# archives
	_pi unar
	_pi zip
	_pi unzip
	_pi 7-zip

	echo ""
fi


if [ "$INST_FAMP" -eq 1 ] ; then
	printf "[ ${CG}NOTE${NC} ]  Installing FAMP stack\n\n"
	
	_pi apache24
	sysrc apache24_enable="YES"

	_pil mariadb ^mariadb[0-9]*-server
	_pil mariadb ^mariadb[0-9]*-client
	sysrc mysql_enable="YES"

	_pil phpmyadmin5 ^phpMyAdmin5-php[0-9]
	ln -s /usr/local/www/phpMyAdmin /usr/local/www/apache24/data/pma
	ln -s /usr/local/www/phpMyAdmin /usr/local/www/apache24/data/phpMyAdmin

	_pil mod_php ^mod_php[0-9]
	cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
	rehash
	cp ${CWD}/config/001_mod-php.conf /usr/local/etc/apache24/modules.d/

	chmod -R 775 /usr/local/www/apache24/data
	echo ""
fi


if [ "$INST_EMACS" -eq 1 ] ; then
	printf "[ ${CG}NOTE${NC} ]  Installing Emacs\n\n"

	_pi emacs
	echo ""
fi