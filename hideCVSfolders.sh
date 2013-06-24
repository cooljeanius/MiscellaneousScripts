#!/bin/bash
#TODO: escape spaces in paths properly

for i in `find * | grep CVS`; do 
	if [ -d ${i} ]; then 
		chflags hidden ${i};
	fi;
done
