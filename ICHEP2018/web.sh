#!/bin/bash


############## COLOR CODE ##############
error(){
    echo -e "${RED}$1${NC}"
}
warn(){
    echo -e "${YELLOW}$1${NC}"
}
info(){
    echo -e "${GREEN}$1${NC}"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
########################################

Name=( "main" "indico" "mirror" )
Server_List=(
	"http://www.ichep2018.org/"
	"https://indico.cern.ch/event/686555/"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/"
)
Status=()

iter=0
for web in ${Server_List[@]}; do
	web_name=$(echo ${Name[$iter]})

	## -- check connection -- ##
	echo "check connection with $web_name..."
	if [ $iter -eq 2 ]; then
		curl -s -o $web_name.log $web/overview.html
	else
		curl -s -o $web_name.log $web
	fi

	## -- check download -- ##
	if [ $iter -eq 1 -o $iter -eq 2 ]; then
		echo "check download from $web_name..."
		curl -s -o $web_name.pdf $web/book-of-abstracts.pdf
	fi

	## -- Is connection ok? -- ##
	if [ -f $web_name.log ]; then
		if [ $iter -eq 0 ]; then
			Status+=($(info "OK"))
		## -- Is download ok? -- ##
		elif [ -f $web_name.pdf ]; then
			Status+=($(info "OK"))
		fi
	else
		Status+=($(error "ERROR"))
	fi

	iter=$(echo "$iter + 1" | bc)
done
echo
echo "Status(main, indico, mirror): (${Status[0]}, ${Status[1]}, ${Status[2]})"

if [ ${Status[0]} = "ERROR" -o ${Status[1]} = "ERROR" -o ${Status[2]} = "ERROR" ]; then
	echo "ERROR is found" | mail -s "check ICHEP2018 web sites" dustmqdyd93@gmail.com
fi
echo "ERROR is found" | mail -s "test: check ICHEP2018 web sites" dustmqdyd93@gmail.com

