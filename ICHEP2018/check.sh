#!/bin/bash


## -- Usage -- ##
## Please run this script in you local computer.
## example command> ./check.sh >&check.log&


Name=( "main" "indico" "mirror" )

while true
do
	for name in ${Name[@]}; do
		rm -f $name.log
		rm -f *.pdf
	done

	date
	./web.sh

	echo "(sleep 1m)"
	sleep 60
	
	echo "-------------------------------------------------------"
done
