#!/bin/bash

for i in `find * | grep CVS`; do 
	if [ -d ${i} ]; then 
		chflags hidden ${i};
	fi;
done
