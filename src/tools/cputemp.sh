#!/bin/sh

# show CPU temps
# requires coretemp_load="YES" in /boot/loader.conf
sysctl dev.cpu | grep temperature
