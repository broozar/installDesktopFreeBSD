# For Developers
If you want to learn more about this project or would like to add your own desktop install script to it, read on.

## General folder structure
The project consists of the following folders:

- build: scripts that create a *.run* package from the *src* folder
- release: target of the build process
- src: true root folder of the project with all code files
- versions: manual changelog

## Source folder structure
Src is the true root folder for the project.

- src/config: various config files that you want to copy into the target system
- src/desktops: install scripts for destop environments, login managers, wallpapers etc. - no functions
- src/include: core scripts for the FreeBSDesktop system - mostly functions
- src/polkit: permission files
- src/themes: theme packages and theme definitions
- src/tools: additional software tools you can copy to the target system

## Adding your own desktop
FreeBSDesktop can be extended with your own desktop installation scripts by following these steps:

1. Install and theme your desktop on an existing installation for FreeBSD. Track all your steps and packages.
2. Dump all your settings into a file, so they can be moved to a fresh installation. This process varies form DE to DE. Take a look at *src/tools/mate-dumpsettings* for inspiration.
3. Create a file in src/desktops, for instance *desktop-kde.sh*. Fill this file with your installation and configuration code.
4. If you want to add startup scripts to every user, modify *src/include/install_skel.sh* around line 30.
5. Add your desktop to *src/include/functions_dia.sh* -> _dde ()
6. Add a variable for your desktop to *src/include/variables.sh*, for instance `INST_KDE=0`
7. Reference your script in *src/main.sh* around line 66, for instance: `if [ "$INST_KDE" -eq 1 ] ; then`

## Building
FreeBSDesktop offers several scripts to package the project.

### Makeself
*build/makeself.sh* creates a self-extracting installer.

1. Make sure *makeself(.sh)* is installed on your system. Install it if necessary.
2. `chmod +x` and run *build/makerun.sh*
3. Your self-extracting archive is located in the release folder.

### Tar/GZ
*build/makestar.sh* and *build/makestargz.sh* create tar and tar.gz archives respectively.

1. `chmod +x` and run *build/maketar.sh* or *build/maketargz.sh*.
2. Your archive is located in the release folder.