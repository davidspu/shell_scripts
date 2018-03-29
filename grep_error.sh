#!/bin/bash

# input validation
numtest='^[^0-9]+$'
if [ "$#" -lt 3 ] || [[ $2 =~ $numtest ]]; then
	echo "Usage: bash grep_error <path> <max seconds backtrack> <regrex>"
	exit 1
fi
if [ ! -e "$1" ]; then 
	echo "File does not exist"
	exit 1
fi
FILEPATH=$1
MAXSECONDS=$2
REGEX=$3

NOW=$(date +%s)
# Get all rows matching regular expression then process line by line
sudo egrep "$REGEX" "$FILEPATH" | 
while read err; do
	# convert the first three words in each error log into timestamp (Jan 01 19:20:20 -> 1514852420)
	T=$(echo $err | awk '{print $1" "$2" "$3}' | xargs -I {} date -d {} +%s)
	# test if the log is within the range
	if test $(($NOW - $T)) -le $MAXSECONDS 
	then 
		echo $err
	fi
done
