#!/bin/bash

# Check if we were effectively run as root
[ $EUID = 0 ] || { echo "This script needs to be run as root!"; exit 1; }


#Change to Xen Orchestra directory
cd /opt/xen-orchestra/

#Check for updates to Xen Orchestra
git checkout .
xoupdatestatus="$(git pull --ff-only)>/dev/null"

#Exit if there are no updates
if [[ $xoupdatestatus == *"Already up-to-date"* ]]; then
   echo "Xen Orchestra is already up-to-date"
   exit
      else
      echo "Updates found"
fi

#Update build dependencies
echo "Updating build dependencies"
yarn>/dev/null
#Build updated version of Xen Orchestra
echo "Building updated XOA"
yarn build>/dev/null

#Restart xo-server
echo "Restarting XO Server to apply updates"
systemctl restart xo-server>/dev/null

echo "XOA has been updated"
exit
