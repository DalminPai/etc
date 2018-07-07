#!/bin/bash


## -- Usage -- ##
## Please run this script in you local computer.
## example command> ./check.sh >&check.log&

############## COLOR CODE ##############
RED_LINE(){
    echo -e "${RED}$1${NC}"
}
YELLOW_LINE(){
    echo -e "${YELLOW}$1${NC}"
}
GREEN_LINE(){
    echo -e "${GREEN}$1${NC}"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
########################################

RED_LINE "NOTE: It will remove log which has specific name and pdf files within 10s."
RED_LINE "Type \"crtl+c\" if you don't want to remove the files." 
echo "(Please see #L16 and #L17 of \"check.sh\" to see rm command.)"
echo

sleep 10

Name=( "main" "indico" "mirror" )

while true
do
	date

	for name in ${Name[@]}; do
		rm -f $name.log
		rm -f *.pdf
	done

	./web.sh

#	echo "(sleep 1m)"
#	sleep 60
	echo "(sleep 5m)"
	sleep 300
	
	echo "-------------------------------------------------------"
done
