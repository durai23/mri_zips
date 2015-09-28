#!/bin/bash
#basic fdt pipeline
base=~/bnst_data
subjlist=(101 104 105 106 110 111)
#modify and run on cluster
#FSL_DIR=
for i in ${subjlist[*]}
do
    echo SUBJECT WZP"$i"B............................

    fslswapdim "$base"/WZP"$i"B/diff/diff.nii "$base"/WZP"$i"B/diff/diff_swp
    cd ~/bnst_data/WZP"$i"B/diff/dicoms
    to3d -assume_dicom_mosaic -prefix WZP"$i"B_diff_60 -time:zt 60 65 9300 alt+z *.dcm
    3dAFNItoNIFTI WZP"$i"B_diff_60+orig 
    rm *orig*
    mv WZP"$i"B_diff_60.nii ../diff.nii

    eddy_correct "$base"/WZP"$i"B/diff/diff \
        "$base"/WZP"$i"B/diff/data 0

    fslroi "$base"/WZP"$i"B/diff/data \
        "$base"/WZP"$i"B/diff/nodif 0 1

    bet "$base"/WZP"$i"B/diff/nodif \
        "$base"/WZP"$i"B/diff/nodif_brain 
        -f 0.35 \
        -g 0 \
        -m
    dtifit --data="$base"/WZP"$i"B/diff/data.nii.gz \
        --out="$base"/WZP"$i"B/diff/dti_mine \
        --mask="$base"/WZP"$i"B/diff/nodif_brain_mask.nii.gz \
        --bvecs="$base"/WZP"$i"B/diff/bvecs \
        --bvals="$base"/WZP"$i"B/diff/bvals    
#bedpostx /home/owner/data_bkup/toydata/test2 --nf=2 --fudge=1  --bi=1000
done


