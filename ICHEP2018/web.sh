#!/bin/bash


# -- progress bar function -- ##
prog() {
    local w=80 p=$1;  shift
    ## create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /=};
    ## print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% of total list %s" "$w" "$dots" "$p" "$*";
}

## -- initializing -- ##
Site_Name=( "main" "indico" "mirror" )
Site_List=(
	"http://www.ichep2018.org/"
	"https://indico.cern.ch/event/686555/"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/overview.html"
	)
## You can modify download list of indico and mirror sites if you need.
Download_List_Indico=(
	"https://indico.cern.ch/event/686555/book-of-abstracts.pdf"
	"https://indico.cern.ch/event/686555/contributions/3028073/attachments/1683947/2706879/201810August_ICHEP_HiggsPlenary_3.pdf"
	"https://indico.cern.ch/event/686555/contributions/3028074/attachments/1683946/2706878/skinnari_TopEW_ICHEP2018.pdf"
	)
Download_List_Mirror=(
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/book-of-abstracts.pdf"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/2969916-contribution/2698170-ICHEP2016_dark_Belle.pdf"
	"http://147.47.50.77/OfflineWebsite-ICHEP2018_SEOUL/files/agenda/3028083-contribution/2704927-ICHEP2018.pdf"
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

## -- Report status by email -- ##
## Please modify "mail_address" if you need.
## If there is a problem in wifi connection, then email will not be sent to you.
mail_address="dustmqdyd93@gmail.com"
echo "Report status by email: $mail_address"
## Contents of email
Line1="Status(main, indico, mirror): (${Totoal_Status[0]}, ${Totoal_Status[1]}, ${Totoal_Status[2]})"
Line2="(sent at `date | grep 2018`)"
## Send email
echo -e "${Line1}\n${Line2}" | mail -s "Status of ICHEP2018 web sites" $mail_address

