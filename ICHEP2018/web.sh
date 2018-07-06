#!/bin/bash


# -- progress bar function -- ##
prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /=};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% of total list %s" "$w" "$dots" "$p" "$*";
}

## -- initializing -- ##
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
#	"https://indico.cern.ch/event/686555/contributions/2972279/attachments/1680191/2699090/Vercaemer_ICHEP18_final.pdf"
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
#	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2972279-contribution/2699090-Vercaemer_ICHEP18_final.pdf"
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

	## -- Connection -- ##
	echo "Connect to $web_name..."
	curl -s -o $web_name.log $web

	## -- Download -- ##
	prog_down=0
	if [ $iter -eq 1 ]; then
		echo "Download from $web_name..."
		for indico_down in ${Download_List_Indico[@]}; do
#			curl -s -O $indico_down
			curl -O $indico_down
			prog_down=$(echo "$prog_down + 1" | bc)
			percent=$(echo "(100*$prog_down + ${#Download_List_Indico[@]}/2)/${#Download_List_Indico[@]}" | bc)
    		prog "$percent"
			echo
		done
	elif [ $iter -eq 2 ]; then
		echo "Download from $web_name..."
		for mirror_down in ${Download_List_Mirror[@]}; do
#			curl -s -O $mirror_down
			curl -O $mirror_down
			prog_down=$(echo "$prog_down + 1" | bc)
			percent=$(echo "(100*$prog_down + ${#Download_List_Mirror[@]}/2)/${#Download_List_Mirror[@]}" | bc)
    		prog "$percent"
			echo
		done
	fi

	## -- Check of connection -- ##
	if [ -f $web_name.log ]; then
		if [ $iter -eq 0 ]; then
			Totoal_Status+=($(echo "OK"))
		## -- Check of download from indico -- ##
		elif [ $iter -eq 1 ]; then
			flag_indico=1
			for indico_down in ${Download_List_Indico[@]}; do
				if [ ! -f $(basename $indico_down) ]; then
					flag_indico=0
				fi
			done

			if [ $flag_indico -eq 0 ]; then
				Totoal_Status+=($(echo "ERROR"))
			else
				Totoal_Status+=($(echo "OK"))
			fi
		## -- Check of download from mirror -- ##
		elif [ $iter -eq 2 ]; then
			flag_mirror=1
			for mirror_down in ${Download_List_Mirror[@]}; do
				if [ ! -f $(basename $mirror_down) ]; then
					flag_mirror=0
				fi
			done

			if [ $flag_mirror -eq 0 ]; then
				Totoal_Status+=($(echo "ERROR"))
			else
				Totoal_Status+=($(echo "OK"))
			fi
		else
			Totoal_Status+=($(echo "ERROR"))
		fi
	else
		Totoal_Status+=($(echo "ERROR"))
	fi

	iter=$(echo "$iter + 1" | bc)
done
echo
echo "Status(main, indico, mirror): (${Totoal_Status[0]}, ${Totoal_Status[1]}, ${Totoal_Status[2]})"

## -- Send a mail if there is an error (Please modify mail address if you need) -- ##
mail_address="dustmqdyd93@gmail.com"
if [ ${Totoal_Status[0]} = "ERROR" -o ${Totoal_Status[1]} = "ERROR" -o ${Totoal_Status[2]} = "ERROR" ]; then
	echo "Error will be informed by email: $mail_address"
	echo "ERROR is found" | mail -s "check ICHEP2018 web sites" $mail_address
fi

