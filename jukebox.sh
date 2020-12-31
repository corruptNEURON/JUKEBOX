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

	INPUT=$( echo $INPUT | awk '{sub(/^0*/,"");}1' )

	# Special case for a toggle card
	if [[ $INPUT -eq "2012737" ]]; then
		mpc toggle
		continue
	fi
	
	# Special cases for volume up and down
	if [[ $INPUT -eq "4488121" ]]; then
		mpc volume +15
		continue
	fi
	
	if [[ $INPUT -eq "4488126" ]]; then
		mpc volume -15
		continue
	fi
	
	if [[ $INPUT -eq "11722165" ]]; then
		mpc stop -q && mpc clear -q && mpc add spotify:album:57ISBWUZKtB3s5se3rhg5S && mpc add spotify:album:4RU9d3qLVIn1ijkorkaAUF && mpc add spotify:album:004XUoyrxdCfkDQJBfYRNF && mpc random && mpc play
		continue
	fi
	
	# Grab the appropriate line from the song list
	SONG=$(awk -v input="$INPUT" '{if ($1 == input) {print $2}}' songs.txt)
	
	mpc stop -q && mpc clear -q && mpc add $SONG && mpc play
done 
