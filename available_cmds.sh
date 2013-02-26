#!/bin/bash
# available_cmds.sh: prints all commands available in your $PATH

# For some reason backticks don't work here, so I have to use $(...) instead
export NUMBER_OF_PATH_DIRS=$(echo $PATH | tr : \\n | wc -l)
export TOTAL_LINES=$(echo $PATH | tr : \\n | xargs ls -1p | wc -l)

printf "\n"
echo "Available commands:"
printf "\n"

export AVAILABLE_COMMANDS=$(echo $PATH | tr : \\n | xargs ls -1p | sort | tail -n $(($TOTAL_LINES - $((2 * $NUMBER_OF_PATH_DIRS)))) | tr \\n \ )

for command in $AVAILABLE_COMMANDS ; do
	if [ -x `which ${command}` ]; then
		printf "${command} "
	fi
done

printf "\n"
printf "\n"
