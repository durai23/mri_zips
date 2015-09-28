#!/bin/bash
#attempt to put T1 in diffusion space using the nodif volume
base=~/bnst_data
subjlist=(100 102 106 107 108 109)
#$base/WZP"$subj"B/
for subj in ${subjlist[*]}
do
    if  [ ! -d "$base/WZP"$subj"B/mats" ]; then
    mkdir $base/WZP"$subj"B/mats

    #convert anat and nodif to BRIKS
    3dcopy $base/WZP"$subj"B/diff/nodif_brain.nii.gz $base/WZP"$subj"B/diff/nodif_brain
    3dcopy $base/WZP"$subj"B/mp/"$subj"_mp_ns.nii $base/WZP"$subj"B/mp/"$subj"_mp_ns
   
    #put T1 in diffusion space
    align_epi_anat.py -anat2epi \
        -giant_move \
        -deoblique off \
        -tshift off \
        -volreg off \
        -anat_has_skull no \
        -anat $base/WZP"$subj"B/mp/"$subj"_mp_ns+orig \
        -epi $base/WZP"$subj"B/diff/nodif_brain+orig \
        -epi_base 0 \
        -suffix _al_2_nodif
    mv ./"$subj"_mp_ns_al_2_nodif_mat.aff12.1D $base/WZP"$subj"B/mats/

    #remove BRIKS and make nifti
    rm $base/WZP"$subj"B/mp/"$subj"_mp_ns+orig*
    rm $base/WZP"$subj"B/diff/nodif_brain+orig*

    3dAFNItoNIFTI "$subj"_mp_ns_al_2_nodif+orig

    mv ./"$subj"_mp_ns_al_2_nodif.nii $base/WZP"$subj"B/diff/
    rm ./"$subj"_mp_ns_al_2_nodif+orig*
done
