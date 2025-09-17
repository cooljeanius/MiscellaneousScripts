#!/bin/bash
# cheat_at_kusari.sh: get distribution of words starting with a certain letter
# by the letter they end with

printf "\n"
if [ "$1" == "--help" ] || [ -z "$1" ]; then
	echo "Usage:"
	echo "cheat_at_kusari.sh [letter]"
	printf "\n"
	exit
fi

for letter in $(perl -E 'say for a..z'); do
    echo "$1...${letter}: $(grep -c -e "^$1.*${letter}$" /usr/share/dict/words)";
done

# TODO: calculate which ending letter has the lowest nonzero total
# then do `grep -e "^$1.*${that_letter}$" /usr/share/dict/words` for it
