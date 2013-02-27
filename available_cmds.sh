#!/bin/bash
# available_cmds.sh: prints all commands available in your $PATH

# For some reason backticks don't work here, so I have to use $(...) instead
export NUMBER_OF_PATH_DIRS=$(echo $PATH | tr : \\n | wc -l)
export TOTAL_LINES=$(echo $PATH | tr : \\n | xargs ls -1p | wc -l)

printf "\n"
if [ "$1" == "--help" ]; then
	echo "Usage:"
	echo "available_cmds.sh [-v] [-q]"
	echo "-v: This flag prints the full path of all found commands."
	echo "-q: This flag keeps the output machine-readable."
	printf "\n"
	exit
fi
if [ "$1" != "-q" ]; then
	echo "Available commands:"
	printf "\n"
fi

export AVAILABLE_COMMANDS=$(echo $PATH | tr : \\n | xargs ls -1p | sort | tail -n $(($TOTAL_LINES - $((2 * $NUMBER_OF_PATH_DIRS)))) | uniq | tr \\n \ )

for command in $AVAILABLE_COMMANDS ; do
	if [ -x `which ${command}` ]; then
		if [ "$1" == "-v" ]; then
			which ${command}
		else
			printf "${command} "
		fi
	fi
done

if [ "$1" != -v ]; then
	printf "\n"
fi
printf "\n"
