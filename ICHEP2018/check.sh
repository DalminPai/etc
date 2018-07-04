#!/bin/bash


Name=( "main" "indico" "mirror" )

while true
do
	for name in ${Name[@]}; do
		rm -f $name.log
		rm -f $name.pdf
	done

	date
	./web.sh

	echo "(sleep 1m)"
	sleep 60
	
	echo "-------------------------------------------------------"
done
