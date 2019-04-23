#!/bin/bash

macro=$1

#for type in $(seq 0 10); do
#    root -l -b -q "$macro($type)"
#done

#for type in 1.3 2 2.1 2.2 3 3.1 3.2 7; do
#for type in 1.43 2.043 2.143 2.243 3.043 3.143 3.243 7.43; do
#for type in 1.42 2.042 2.142 2.242 3.042 3.142 3.242 7.42; do
#for type in 1.41 2.041 2.141 2.241 3.041 3.141 3.241 7.41; do
#for type in 1.1 2.001 2.101 2.201 3.001 3.101 3.201 7.001; do
#for type in -2 -2.1 -2.2 -3 -3.1 -3.2; do
#    root -l -b -q "$macro($type, \"BtoH\")"
#    root -l -b -q "$macro($type, \"GtoH\")"
#done

## -- Muon channel -- ##
#for era in 1 2 3 4 5 BtoF 6 7 GtoH BtoH; do
#    for var in 1.1 1.2 -1.3 -1.301 -1.302 -1.303 1.3; do
#    for var in -3 -3.001 -3.002 -3.003 3; do
#        root -l -b -q "$macro($var, \"$era\")"
#    done
#done

## -- Muon channel with run dependency -- ##
#for era in B C D E F G H; do
#    root -l -b -q "$macro(5, \"$era\")"
#    for i in $(seq 155 175); do
#        var=$(echo "5+${i}*0.001" | bc)
#        root -l -b -q "$macro($var, \"$era\")"
#    done
#done

## -- for mycode_plot.cc -- ##
#for era in 1 2 3 4 5 BtoF 6 7 GtoH; do
#    for var in 1 1.1 1.2 1.3 1.4 1.5 1.6; do
#        root -l -b -q "$macro($var, \"$era\")"
#    done
#done

## -- Electron channel -- ##
#for era in 1 2 3 4 5 6 7 BtoH; do
#    for var in 1.1 1.2 -1.3 -1.301 1.3; do ## mass
#    for var in 3.3 3.4 -3 -3.001 3; do ## eta
#        root -l -b -q "$macro($var, \"$era\")"
#    done
#done


#for type in 8; do
#    for i in $(seq 1 11); do
#	#num=$(echo "${type}+0.1+${i}*0.001" | bc)
#	num=$(echo "${type}+${i}*0.001" | bc)
#        root -l -b -q "$macro($num)"
#    done
#done

#for type in 2.1 2.2 3.1 3.2; do
#	for mc in "aMC@NLO" "Powheg" "MadGraph"; do
#		root -l -b -q "$macro(\"MuMu\", $type, \"$mc\")"
#	done
#done

#for type in 1 2 2.1 2.2 3 3.1 3.2 4 4.1 4.2 5 6; do
#for type in 3 3.1 3.2 6; do
for type in 0 2 3; do
#for type in 0 2 3.3; do
    root -l -b -q "$macro($type, \"MuMu\")"
#    root -l -b -q "$macro($type, \"EE\")"
done

