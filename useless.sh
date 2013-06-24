#!/bin/bash
#TODO: paste

if [ -d ./ ]; then
	echo "hello world"
else
	exit 0
fi

pwd
whoami
cat $0
if [ -z "$(ps -c | grep "bash")" ]; then
	ps
	ps | wc
	time bash $0
	ps
	ps | wc
elif [ -z "$(ps -c | grep "zsh")" ]; then
	ps
	ps | wc
	time zsh $0
	ps
	ps | wc
elif [ -z "$(ps -c | grep "ksh")" ]; then
	ps
	ps | wc
	time ksh $0
	ps
	ps | wc
elif [ -z "$(ps -c | grep "sh")" ]; then
	ps
	ps | wc
	time sh $0
	ps
	ps | wc
else
	echo "Sorry, can't let you do that"
fi


