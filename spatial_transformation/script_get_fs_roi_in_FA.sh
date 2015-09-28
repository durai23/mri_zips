#!/bin/bash
#This will fetch freesurfer ROIs if you supply the id's from the lookup table (LUT)
#supply subject list and LUT IDs below base=~/bnst_data
base=~/bnst_data
fshome=/home/owner/Desktop/freesurfer
subjlist=(101 102 104 105 106 107 108 109 110 111)
lutlist=(2 3 9 10 17 18 53 54 1029 2029 1024 2024 1027 2027 1012 2012 1010 2010 1023 2023 1002 2002 1026 2026)
for subj in ${subjlist[*]}
do
    if [ ! -d ""$base"/WZP"$subj"B/FSROI" ]; then
        mkdir "$base"/WZP"$subj"B/FSROI
    fi
    for lutid in ${lutlist[*]}
    do
        #get roi name from LUT and remove space
        rname=$(awk '$1=='$lutid' {print " "$2}' "$fshome"/FreeSurferColorLUT.txt); rname=$(echo""$rname"" | tr -d ' ');

        #binarize
        mri_binarize --match $lutid \
            --i "$base"/WZP"$subj"B/mri/aparc+aseg.mgz \
            --o "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".mgz

        #convert to nifti
        mri_convert -rl "$base"/WZP"$subj"B/mri/orig/001.mgz \
            -rt nearest "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".mgz \
            "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".nii 

        rm "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".mgz

        #affine to FA space
	    echo "FLIRTING>>>>>>>>>SUBJECT WZP"$subj"B>>>>>>>>>>>>>ROI>>>>>>>>"$rname"<<<<<<<<<<<"
	    flirt -in "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".nii \
            -ref "$base"/WZP"$subj"B/diff/dti_mine_FA.nii.gz \
            -out "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname"_2_fa \
            -applyxfm \
            -init "$base"/WZP"$subj"B/mats/"$subj"_mp_ns_rpi_2_fa_ncorr.mat

	    rm "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname".nii
        
        #rebinarize after affine
	    fslmaths "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname"_2_fa.nii.gz -bin "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname"_2_fa_bin
	    rm "$base"/WZP"$subj"B/FSROI/WZP"$subj"B_"$rname"_2_fa.nii.gz
    done
done
