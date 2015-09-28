#!/bin/bash
#this is the best way to put a T1 in diffusion space using the FA rather than nodif volume and flirt with below settings
#AEA.py did not work as well with FA
subjlist=(100 102 106 107 108 109)
base=~/bnst_data
#$base/WZP"$subj"B/
for subj in ${subjlist[*]}
do
    if  [ ! -d "$base/WZP"$subj"B/mats" ]; then
	mkdir $base/WZP"$subj"B/mats
    fi
    #convert anat and nodif to BRIKS
    #3dcopy $base/WZP"$subj"B/diff/dti_mine_FA.nii.gz $base/WZP"$subj"B/diff/dti_FA
    #3dcopy $base/WZP"$subj"B/mp/"$subj"_mp_ns.nii $base/WZP"$subj"B/mp/"$subj"_mp_ns
    flirt -in $base/WZP"$subj"B/mp/"$subj"_mp_ns.nii \
        -ref $base/WZP"$subj"B/diff/dti_mine_FA.nii.gz \
        -out $base/WZP"$subj"B/diff/"$subj"_mp_ns_2_fa_ncorr \
        -omat $base/WZP"$subj"B/mats/"$subj"_mp_ns_2_fa_ncorr.mat \
        -bins 256 \
        -cost normcorr \
        -searchrx -180 180 \
        -searchry -180 180 \
        -searchrz -180 180 \
        -dof 12 \
        -interp trilinear
    #align_epi_anat.py -anat2epi -giant_move -deoblique off -tshift off -volreg off -anat_has_skull no -anat $base/WZP"$subj"B/mp/"$subj"_mp_ns+orig -epi $base/WZP"$subj"B/diff/nodif_brain+orig -epi_base 0 -suffix _al_2_nodif
    #mv ./"$subj"_mp_ns_al_2_nodif_mat.aff12.1D $base/WZP"$subj"B/mats/
    #rm $base/WZP"$subj"B/mp/"$subj"_mp_ns+orig*
    #rm $base/WZP"$subj"B/diff/dti_FA+orig*
    #3dAFNItoNIFTI "$subj"_mp_ns_al_2_nodif+orig
    #mv ./"$subj"_mp_ns_al_2_nodif.nii $base/WZP"$subj"B/diff/
    #rm ./"$subj"_mp_ns_al_2_nodif+orig*
done
