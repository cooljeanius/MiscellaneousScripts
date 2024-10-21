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

# shellcheck disable=SC2044
for directory in $(find "${DIR_TO_UNEMPTY}"/* -perm +r -user "$(whoami)"); do
    echo "${directory}"
	if [ -d "${directory}" ]; then
		echo "Entering ${directory}..."
		cd "${directory}" || exit
		# shellcheck disable=SC2010
		directoryContents=$(ls -a "${directory}"/* 2>/dev/null | grep -v .DS_Store)
		if [ -z "${directoryContents}" ]; then
			if [ "$(basename "${directory}")" = ".deps" ]; then
				echo "skipping unemptying .deps dir"
				rmdir "${directory}" 2>&1 || stat "${directory}"
			elif [ "$(basename "${directory}")" = ".libs" ]; then
				echo "skipping unemptying .libs dir"
				rmdir "${directory}" 2>&1 || stat "${directory}"
			elif [ ! -f "${directory}"/.gitignore ]; then
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
	# no "else" here; that would just be too noisy to note all non-directories
	fi
done

