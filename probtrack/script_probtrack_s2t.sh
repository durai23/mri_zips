#!/bin/bash
base=~/bnst_data
subjlist=(101 102 104 105 106 107 108 109 110 111)
#if [ 1 -eq 0 ]; then
for i in ${subjlist[*]}
do
    echo **********WZP"$i"B*************
    #fetch targets file and put it in base
    cp "$base"/targets2.txt "$base"/WZP"$i"B/WZP"$i"B_lcing_targets2.txt
    #make base subject specific
    sed -i "s/WZP100B/WZP"$i"B/g" "$base"/WZP"$i"B/WZP"$i"B_lcing_targets2.txt
    #run probtrackx 
	probtrackx2 -x "$base"/WZP"$i"B/FSROI/WZP"$i"B_lcing_2_fa_bin.nii.gz \
    -l \
    --onewaycondition \
    -c 0.2 \
    -S 5000 \                                                                       #5000 seeds
    --steplength=0.5 \
    -P 1500 \
	--fibthresh=0.01 \
    --distthresh=0.0 \
    --sampvox=0.0 \
	--avoid="$base"/WZP"$i"B/WZP"$i"B_cing_exclude.nii.gz \                         #roa
    --forcedir \
    --opd \
	-s "$base"/WZP"$i"B/diff.bedpostX/merged \
    -m "$base"/WZP"$i"B/diff.bedpostX/nodif_brain_mask \                            #brain mask used
	--dir="$base"/WZP"$i"B/lcing_1 \                                                #directory to store results
    --targetmasks="$base"/WZP"$i"B/WZP"$i"B_lcing_targets2.txt \                    #location to target masks 
    --os2t                                                                          #seeds to targets tracking

    #threshold fdt_paths
    fslmaths "$base"/WZP"$i"B/lcing_1/fdt_paths.nii.gz \
        -thrP 80 \
        "$base"/WZP"$i"B/lcing_1/fdt_paths_80

    #affine fdt_paths to rpi using mat from subject folder
    flirt -in "$base"/WZP"$i"B/lcing_4/fdt_paths.nii.gz \
        -ref "$base"/WZP"$i"B/mp/"$i"_mp_ns_rpi \
        -out "$base"/WZP"$i"B/lcing_4/fdt_paths_2_mp_ns_rpi \
        -init "$base"/WZP"$i"B/mats/"$i"_fa_2_mp_ns_ncorr.mat \
        -applyxfm

    #warp fdt_paths to MNI space
    applywarp --ref=/usr/local/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz \
        --in="$base"/WZP"$i"B/lcing_4/fdt_paths_2_mp_ns_rpi \
        --warp="$base"/WZP"$i"B/mp/coef_"$i"_mp_to_MNI2mm.nii.gz \
        --out="$base"/WZP"$i"B/lcing_4/"$i"_lcing_paths_2_MNI    

    #calculte mean
    stats_mean=$(fslstats "$base"/WZP"$i"B/lcing_4/"$i"_lcing_paths_2_MNI.nii.gz -M)

    #normalize over mean
    fslmaths "$base"/WZP"$i"B/lcing_4/"$i"_lcing_paths_2_MNI.nii.gz \
    -div stats_mean "$base"/WZP"$i"B/lcing_4/"$i"_lcing_paths_2_MNI_N
    
    mv "$base"/WZP"$i"B/lcing_4/"$i"_lcing_paths_2_MNI_N.nii.gz "$base"/lcing/
done
#fi


