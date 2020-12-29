#!/bin/bash

# Update songs list
echo "Updating song list"
curl -s -S https://raw.githubusercontent.com/corruptNEURON/JUKEBOX/main/songs.txt > songs.txt

echo "Jukebox started!"

while read -ep "Tap: " INPUT; do

	# No number found, bail
	if [[ -z "$INPUT" ]]; then
		continue
	fi
	
	echo $INPUT
	
	INPUT=$( echo $INPUT | awk '{sub(/^0*/,"");}1' )
	
	echo $INPUT

	# Special case for a toggle card
	if [[ $INPUT -eq "2012737" ]]; then
		mpc toggle
		continue
	fi
	
	# Grab the appropriate line from the song list
	URI=$(awk '{if ($2 == $INPUT); print $1}' songs.txt)
	
	echo $URI
	
	mpc stop -q && mpc clear -q && mpc add $URI && mpc play
done
