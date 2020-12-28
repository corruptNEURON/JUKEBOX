#!/bin/bash

# Update songs list
echo "Updating song list"
curl -s -S https://raw.githubusercontent.com/corruptNEURON/JUKEBOX/main/songs.csv > songs.csv

echo "Jukebox started!"

while read -ep "Tap: " INPUT; do

	# No number found, bail
	if [[ -z "$INPUT" ]]; then
		continue
	fi
	
	print $INPUT

	# Trim leading zeros so it doesn't think this is octal or whatever
	INPUT=$( echo $INPUT | sed 's/^0*//' )

	# Special case for a toggle card - I hope there are never 1000 plastic cards floating around my house
	if [[ "$INPUT" -eq "2012737" ]]; then
		mpc toggle
		continue
	fi

	# Grab the appropriate line from the song list
	URI=$( awk -F',' '{ if ($1=="${INPUT}") { print $2 } }' songs.csv)
	
	
	if [[ -z "$URI" ]]; then
		continue
	fi

	mpc stop -q && mpc clear -q && mpc add "$URI" && mpc play
done
