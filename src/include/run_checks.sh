# root
MY_ID=$(id -u)
if [ "$MY_ID" -ne 0 ]; then
	_abortmsg "[ ${CR}ERROR${NC} ]  This script needs to be run as ${CC}root user${NC}."
fi
printf "[ ${CG}INFO${NC} ]  Running as root\n"

# arch
MY_ARCH=$(uname -m)
printf "[ ${CG}INFO${NC} ]  Processor architecture: $MY_ARCH\n"

# pkg bootstrap
case "$(/usr/sbin/pkg -N 2>&1)" in
	*" not "*) 
		printf "[ ${CG}INFO${NC} ]  PKG will be bootstrapped\n"
		INST_PKG=1
		;;
	*) 
		printf "[ ${CY}NOTE${NC} ]  PKG was bootstrapped before\n"
		INST_PKG=0
		;;
esac

# biosefi
R=$(sysctl machdep.bootmethod)
case "$R" in
	*BIOS*)	printf "[ ${CG}INFO${NC} ]  Booted from BIOS\n" ;;
	*) 		printf "[ ${CY}WARN${NC} ]  Booted from UEFI. Graphics drivers might not work!\n" ;;
esac

# network
if nc -zw1 8.8.8.8 443 > /dev/null 2>&1 ; then
	printf "[ ${CG}INFO${NC} ]  Internet connection detected\n"
else
	printf "[ ${CY}NOTE${NC} ]  Could not verify internet connection!\n"
	printf "[ ${CY}NOTE${NC} ]  You must be online for this script to work!\n"
	printf "[ ${CY}NOTE${NC} ]  Proceed with caution...\n\n"
fi


# overrides - UNUSED & DEPRECATED
while getopts ":xud" opt; do
	case $opt in
		x)
			INST_XORG=0
			printf "[ ${CY}NOTE${NC} ]  -x: Xorg will not be explicitly installed!\n"
			;;
		u)
			FBSD_UPD=1
			printf "[ ${CY}NOTE${NC} ]  -u: Installing FreeBSD updates! [ ${CC}:q${NC} ] to continue after updates.\n"
			;;
		d)
			DIA_ON=0
			printf "[ ${CY}NOTE${NC} ]  -d: Dialog UI is disabled! Using traditional CLI.\n"
			;;
	esac
done