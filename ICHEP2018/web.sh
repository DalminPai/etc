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

Site_Name=( "main" "indico" "mirror" )
Site_List=(
	"http://www.ichep2018.org/"
	"https://indico.cern.ch/event/686555/"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/overview.html"
	)
Download_List_Indico=(
	"https://indico.cern.ch/event/686555/book-of-abstracts.pdf"
	"https://indico.cern.ch/event/686555/contributions/2971169/attachments/1681020/2700703/marsicano_ichep18.pdf"
	"https://indico.cern.ch/event/686555/contributions/2979566/attachments/1681046/2700746/20180705_hps_ichep.pdf"
	"https://indico.cern.ch/event/686555/contributions/2972279/attachments/1680191/2699090/Vercaemer_ICHEP18_final.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2972285/attachments/1680861/2700398/Diaz-MiniBooNE.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2986848/attachments/1681062/2700771/ICHEP.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2970881/attachments/1680795/2700281/triple-top_ICHEP.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2983616/attachments/1680921/2700854/FlackeICHEP2018.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2975600/attachments/1680793/2700272/icheptalk_Ligang_Xia.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2976694/attachments/1680565/2699821/Micromegas_ICHEP21018.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2976695/attachments/1680269/2699234/mherrmann_2m2MMperfomanceNcalibration.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2971559/attachments/1680936/2700529/Higgs_precision_implication_ICHEP_070518.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2960207/attachments/1681084/2700811/V_Myronenko_ICHEP2018.pdf"
#	"https://indico.cern.ch/event/686555/contributions/2961453/attachments/1680979/2700625/July-5-2018_conf_2.pdf"
	)
Download_List_Mirror=(
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/book-of-abstracts.pdf"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2970881-contribution/2700281-triple-top_ICHEP.pdf"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2983616-contribution/2700493-FlackeICHEP.pdf"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2972279-contribution/2699090-Vercaemer_ICHEP18_final.pdf"
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2972285-contribution/2700398-Diaz-MiniBooNE.pdf"
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2975600-contribution/2700272-icheptalk_Ligang_Xia.pdf"
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2976694-contribution/2699821-Micromegas_ICHEP21018.pdf"
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2976695-contribution/2699234-mherrmann_2m2MMperfomanceNcalibration.pdf"
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2971559-contribution/2700529-Higgs_precision_implication_ICHEP_070518.pdf"
	)
Totoal_Status=()

iter=0
for web in ${Site_List[@]}; do
	web_name=$(echo ${Site_Name[$iter]})

	## -- check connection -- ##
	echo "check connection with $web_name..."
	curl -s -o $web_name.log $web

	## -- check download -- ##
	if [ $iter -eq 1 ]; then
		echo "check download from $web_name..."
		for indico_down in ${Download_List_Indico[@]}; do
			curl -O $indico_down
		done
	elif [ $iter -eq 2 ]; then
		echo "check download from $web_name..."
		for mirror_down in ${Download_List_Mirror[@]}; do
			curl -O $mirror_down
		done
	fi

	## -- Is connection ok? -- ##
	if [ -f $web_name.log ]; then
		if [ $iter -eq 0 ]; then
			Totoal_Status+=($(info "OK"))
		## -- Is download from indico ok? -- ##
		elif [ $iter -eq 1 ]; then
			flag_indico=1
			for indico_down in ${Download_List_Indico[@]}; do
				if [ ! -f $(basename $indico_down) ]; then
					flag_indico=0
				fi
			done

			if [ $flag_indico -eq 0 ]; then
				Totoal_Status+=($(error "ERROR"))
			else
				Totoal_Status+=($(info "OK"))
			fi
		## -- Is download from mirror ok? -- ##
		elif [ $iter -eq 2 ]; then
			flag_mirror=1
			for mirror_down in ${Download_List_Mirror[@]}; do
				if [ ! -f $(basename $mirror_down) ]; then
					flag_mirror=0
				fi
			done

			if [ $flag_mirror -eq 0 ]; then
				Totoal_Status+=($(error "ERROR"))
			else
				Totoal_Status+=($(info "OK"))
			fi
		## -- Otherwise -- ##
		else
			Totoal_Status+=($(error "ERROR"))
		fi
	else
		Totoal_Status+=($(error "ERROR"))
	fi

	iter=$(echo "$iter + 1" | bc)
done
echo
echo "Status(main, indico, mirror): (${Totoal_Status[0]}, ${Totoal_Status[1]}, ${Totoal_Status[2]})"

## -- Send a mail if there is an error -- ##
if [ ${Totoal_Status[0]} = "ERROR" -o ${Totoal_Status[1]} = "ERROR" -o ${Totoal_Status[2]} = "ERROR" ]; then
	echo "ERROR is found" | mail -s "check ICHEP2018 web sites" dustmqdyd93@gmail.com
fi

