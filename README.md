# installDesktopFreeBSD
FreeBSD desktop installer

## About
This script helps you set up a desktop system on top of FreeBSD 10/11. It will install PKG, X, a Desktop Environment of your choice, some optional Desktop software and set up a 'wheel/video' user.

## Usage
1. Install FreeBSD, but do not create any additional users
2. Copy the installDesktop.sh script onto a USB flash drive and stick it into your freshly installed FreeBSD machine
3. Log in as root, mount the stick and execute the script. This could look something link this (replace locations appropriately):
```
$ mount_msdosfs /dev/da0s1 /mnt
$ /mnt/installDesktop.sh
```
4. Follow the instructions on screen. If you made a mistake, use CTRL+C to abort, then simply run the script again.

## Advanced options
You can launch the script with additional parmeters:

-x skips the Xorg installation
-u skips freebsd-update

## Known issues
GNOME seems to work (and look) best - recommended desktop
KDE untested, because KDE4 is so old now
CINNAMON produces only a black screen... help?

Code::Blocks install is currently borked in 11.1 (startup crash), so you probably need to manually install it from ports

No graphics driver installation, this has to be done manually.

## Changelog
2018-01-11: added -x -u parameters, fixes for KDE/VLC, new network check, Xorg installed by default, echo -y removed, added freebsd-update
2018-01-02: Initial release