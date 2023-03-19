# ------------------------------------ text-only message functions

# yes/no question function - default NO
# return variable
# $1 question
_n () {
	read -p "$1" response
	if echo "$response" | grep -iq "^y" ; then
		return 1
	else
		return 0
	fi
}

_abort () {
	clear
	printf "Installation aborted.\n"
	exit 1
}

_abortmsg () {
	clear
	printf "$1\n"
	printf "Installation aborted.\n"
	exit 1
}

_anykey () {
	echo ""
	read -p "Press Enter/Return to continue..." disregard
	clear
}


# ------------------------------------ patch

_patches () {
	if [ "$FBSD_UPD" -eq 1 ] ; then
		printf "[ ${CG}NOTE${NC} ]  Applying latest FreeBSD security patches\n\n"
		freebsd-update fetch install
		echo ""
	else
		printf "[ ${CY}NOTE${NC} ]  Skipping FreeBSD security patches\n"
	fi
}


# ------------------------------------ pkg

# pkg bootstrap
_pkgboot () {
	if [ "$INST_PKG" -eq 1 ] ; then
		printf "[ ${CG}NOTE${NC} ]  Bootstrapping PKG\n\n"
		env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg
		echo ""
	else
		printf "[ ${CY}NOTE${NC} ]  Skipping PKG bootstrap\n"
	fi

	mkdir -p /usr/local/etc/pkg/repos
	touch /usr/local/etc/pkg/repos/FreeBSD.conf

	echo 'FreeBSD: {
	  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
	  mirror_type: "srv",
	  enabled: yes
	}' > /usr/local/etc/pkg/repos/FreeBSD.conf

	sed -i ".bak" "s/pkg.FreeBSD.org/pkg.${MIRR_PKG}FreeBSD.org/" /usr/local/etc/pkg/repos/FreeBSD.conf
	rm /usr/local/etc/pkg/repos/FreeBSD.conf.bak

	if pkg update -f ; then
		echo "" # pkg was updated, we can continue
	else
		printf "[ ${CR}ERROR${NC} ]  PKG update failed\n"
		exit 1
	fi
}

# automatic pkg package install
# $1 package name
_pi () {
	pkg install -y "$1"
	echo ""
}

# automatic pkg package install with notification header
# $1 package name $2 notification text
_pih () {
	printf "[ ${CG}NOTE${NC} ]  Installing $2\n\n"
	pkg install -y "$1"
	echo ""
}

# automatic pkg package install - latest version
# $1 package search $2 grep regex
_pil () {
	pkg search "$1" | grep -i "$2" | sort -rV | head -n1 | cut -d " " -f1 | xargs pkg install -y
	echo ""
}