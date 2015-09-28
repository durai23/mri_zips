#!/bin/bash
#will take rois from H-O atlas in MNI and save them as binary masks in subject T1 AND nodif space in subject roi folder 
base=~/bnst_data 
sublist=(100 102 107 108 109)
#roi probability threshold
thrld=70
for subj in ${subjlist[*]}
do
#cortical stuff
    date
    echo "SUBJECT $subj"
    for i in {1..48}
    do
		roi=$(sed '17,64!d' $FSL_DIR/data/atlases/HarvardOxford-Cortical.xml |	awk -F'">' '{gsub(/<.*/,"",$2);print $2;}' | awk "NR==$i")	\
		    j=$(($i-1))
		roi=$(echo $roi | sed -e 's/ /_/g')
		#2mm means less accuracy but less time and system hangs
		fslroi $FSL_DIR/data/atlases/HarvardOxford/HarvardOxford-cort-prob-2mm.nii.gz $base/MNI/cort/"$roi" $j 1
		#just apply probability threshold to ROI and not binarize it
		fslmaths $base/MNI/cort/"$roi".nii.gz -thr $thrld $base/MNI/cort/"$roi"_"$thrld"
		rm $base/MNI/cort/"$roi".nii.gz
		#L and R separation begins
		for orient in l r
    	do	
			#multiply by hemi-MNI maps to get accurate hemisphere ROI
			fslmaths $base/MNI/cort/"$roi"_"$thrld" \
				-mul $base/MNI/MNI2mm_"$orient".nii.gz \
				$base/MNI/cort/"$roi"_"$thrld"_"$orient"

			rm $base/MNI/cort/"$roi"_"$thrld".nii.gz

			#warp from MNI to T1 using existing matrix
			applywarp --ref="$base"/WZP"$subj"B/mp/"$subj"_mp.nii \
				--in="$base"/MNI/cort/"$roi"_"$thrld"_"$orient".nii.gz \
				--warp="$base"/WZP"$subj"B/mp/coef_MNI2mm_to_"$subj"_mp.nii.gz \
				--out="$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient"

			#affine to FA space using existing mat
			flirt -in "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient".nii.gz \
				-ref "$base"/WZP"$subj"B/diff/dti_mine_FA.nii.gz \
				-out "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient"_2_fa \
				-applyxfm \
				-init "$base"/WZP"$subj"B/mats/"$subj"_mp_ns_2_fa_ncorr.mat

			rm "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient".nii.gz

			#time to binarize
			fslmaths "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient"_2_fa.nii.gz \
				-bin "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient"_2_fa_bin
			rm "$base"/WZP"$subj"B/roi/cort/WZP"$subj"B_"$roi"_"$thrld"_"$orient"_2_fa.nii.gz
		done
    done
#subcortical stuff
    for i in {1..21}
    do
		roi=$(sed '17,37!d' $FSL_DIR/data/atlases/HarvardOxford-Subcortical.xml | awk -F'">' '{gsub(/<.*/,"",$2);print $2;}' | awk "NR==$i")	\
		    j=$(($i-1))
		roi=$(echo $roi | sed -e 's/ /_/g')
		#2mm means less accuracy but less time and system hangs
		fslroi $FSL_DIR/data/atlases/HarvardOxford/HarvardOxford-sub-prob-2mm.nii.gz $base/MNI/sub/"$roi" $j 1
		#just apply probability threshold to ROI and not binarize it
		fslmaths $base/MNI/sub/"$roi".nii.gz -thr $thrld $base/MNI/sub/"$roi"_"$thrld"
		rm $base/MNI/sub/"$roi".nii.gz
		#no L and R separation for sub!!!
		applywarp --ref="$base"/WZP"$subj"B/mp/"$subj"_mp.nii \
			--in="$base"/MNI/sub/"$roi"_"$thrld".nii.gz \
			--warp="$base"/WZP"$subj"B/mp/coef_MNI2mm_to_"$subj"_mp.nii.gz \
			--out="$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld"

		flirt -in "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld".nii.gz \
			-ref "$base"/WZP"$subj"B/diff/dti_mine_FA.nii.gz \
			-out "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld"_2_fa \
			-applyxfm \
			-init "$base"/WZP"$subj"B/mats/"$subj"_mp_ns_2_fa_ncorr.mat

		rm "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld".nii.gz

		fslmaths "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld"_2_fa.nii.gz \
			-bin "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld"_2_fa_bin

		rm "$base"/WZP"$subj"B/roi/sub/WZP"$subj"B_"$roi"_"$thrld"_2_fa.nii.gz

    done
#make cerebrum masks
fslmaths $base/WZP"$subj"B/roi/sub/WZP"$subj"B_Left_Cerebral_Cortex_"$thrld"_2_fa_bin.nii.gz \
	-add $base/WZP"$subj"B/roi/sub/WZP"$subj"B_Left_Cerebral_White_Matter_"$thrld"_2_fa_bin.nii.gz \
	$base/WZP"$subj"B/roi/sub/WZP"$subj"B_Left_Cerebrum_"$thrld"_2_fa_bin.nii.gz
fslmaths $base/WZP"$subj"B/roi/sub/WZP"$subj"B_Right_Cerebral_Cortex_"$thrld"_2_fa_bin.nii.gz \
	-add $base/WZP"$subj"B/roi/sub/WZP"$subj"B_Right_Cerebral_White_Matter_"$thrld"_2_fa_bin.nii.gz \
	$base/WZP"$subj"B/roi/sub/WZP"$subj"B_Right_Cerebrum_"$thrld"_2_fa_bin.nii.gz
done
	

	
