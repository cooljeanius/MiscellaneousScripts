#!/bin/sh -x
# Originally taken from the Mono installer DMG.
# Edited to be more verbose and stuff.

set -ex

#This script removes Mono from an OS X System.
# It must be run as root.

if [ "x`whoami`" != "xroot" ]; then
   echo "This script must be run as root."
   exit 1
fi

rm -rv /Library/Frameworks/Mono.framework

# In 10.6+ the receipts are stored here:
rm -v /var/db/receipts/com.ximian.mono*

for dir in /usr/bin /usr/share/man/man1 /usr/share/man/man3 /usr/share/man/man5; do

   echo "Looking in ${dir}..."
   (cd ${dir};

    for i in $(ls -al | grep /Library/Frameworks/Mono.framework/ | awk '{print $9}'); do
      echo "Deleting ${i}..."
      rm ${i}

    done);

done

