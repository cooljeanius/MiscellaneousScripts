#!/bin/bash

if [ ! -x `which chflags` ]; then
	echo "This script only works on platforms with a working chflags."
	exit 1
fi

echo "Running $0 in `pwd`..."
echo "(taking a directory as an argument has yet to be implemented)"
#TODO: get spaces in paths to escape properly (the current method doesn't work...)
for i in $(echo "$(find * | grep CVS | sed 's/ /\\ /g')"); do 
	# This echo statement can be removed once spaces are escaped properly
	echo "${i}"
	if [ -d ${i} ]; then
		echo "Hiding ${i}..."
		chflags hidden ${i};
	fi;
done
