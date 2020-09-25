#!/bin/bash

DIR_TO_UNEMPTY=$1
if [ -z "${DIR_TO_UNEMPTY}" ]; then
    DIR_TO_UNEMPTY=~
fi
echo "DIR_TO_UNEMPTY=${DIR_TO_UNEMPTY}"

if [ -x "$(which clear)" ]; then
	clear
	echo "finding directories to unempty..."
	echo "(this could take a while)"
	echo "(also hope you have a large scrollback buffer)"
fi

for directory in $(find "${DIR_TO_UNEMPTY}"/*); do
    echo "${directory}"
	if [ -d "${directory}" ]; then
		echo "Entering ${directory}..."
		cd "${directory}" || exit
		directoryContents=$(ls -a "${directory}"/* 2>/dev/null)
		if [ -z "${directoryContents}" ]; then
			if [ ! -f "${directory}"/.gitignore ]; then
				echo "  VVV"
				echo "• Making '${directory}' not empty..."
				echo "  ^^^"
				echo "#" >> "${directory}"/.gitignore
			else
				echo "Looks like '${directory}' has already been unemptied..."
			fi
		else
			echo "'${directory}' is not empty, skipping..."
		fi
	# no "else" here; that would make no sense
	fi
done

