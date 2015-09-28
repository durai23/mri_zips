#!/bin/bash
#This will combine freesurfer ROIs if you supply the id's from the lookup table (LUT)
#supply subject list and LUT IDs below 
base=~/bnst_data
fshome=/home/owner/Desktop/freesurfer
combined_roi=rcing
subjlist=(101 102 104 105 106 107 108 109 110 111)
lutlist=(2 3 2002 2010 2023 2026)
for subj in ${subjlist[*]}
do
    count=1
#    if [ ! -d ""$base"/WZP"$subj"B/FSROI" ]; then
#        mkdir "$base"/WZP"$subj"B/FSROI
#    fi
    for lutid in ${lutlist[*]}
    do
        rname[count]=$(awk '$1=='$lutid' {print " "$2}' "$fshome"/FreeSurferColorLUT.txt)               #get roi name from LUT
	    rname[count]=$(echo""${rname[count]}"" | tr -d ' ')                                             #remove spaces
	    # echo ${rname[count]}
	    count=$((count+1))
    done

    #echo _"${rname[1]}"_
    addstr="fslmaths "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"${rname[1]}"_2_fa_bin.nii.gz"               #base roi declared

    for ((i=2;i<=count;i++)) 
    do
        addstr=addstr" -add "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"${rname["$i"]}"_2_fa_bin.nii.gz"     #other roi's added in loop
    done

    addstr=addstr" "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$combined_roi"_2_fa_bin"                      #append name of new combined roi
    eval $addstr        `                                                                               #call fslmaths command
done


