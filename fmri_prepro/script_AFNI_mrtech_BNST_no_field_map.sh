#!/bin/bash

#Fieldmap MAGnitude 4.92 and 7.38
#Fieldmap PHASE use to make fmap_rads
#rs-fMRI

subjlist=(WZP111B)
epilist=(EPI1 EPI2)

for subj in ${subjlist[*]}
do
	for epi in ${epilist[*]}

		tap afni-new
		tap fsl-new

		#volreg, despiking, mask, intensity normalization, spatial smoothing, 3dToutcount

		cd /export/data/mrtech/BNST/dra/"$subj"/

		3dvolreg -tshift 0 \
			-twopass -1Dfile "$subj"_"$epi"_volreg_parameters \
			-prefix "$subj"_"$epi"_volreg \
			-float "$subj"_"$epi"+orig

		3dDespike -NEW \
			-prefix "$subj"_"$epi"_volreg_despike \
			"$subj"_"$epi"_volreg+orig

		3dAutomask -dilate 2 \
			-prefix "$subj"_"$epi"_BrainMask \
			"$subj"_"$epi"_volreg_despike+orig

		3dcalc -a "$subj"_"$epi"_volreg_despike+orig \
			-b "$subj"_"$epi"_BrainMask+orig \
			-prefix "$subj"_"$epi"_ns -expr "a*step(b)"
	        
		3dTstat -prefix "$subj"_"$epi"_mean \
			"$subj"_"$epi"_ns+orig

        3dcalc -a "$subj"_"$epi"_ns+orig	\
	        -b "$subj"_"$epi"_mean+orig	\
		    -expr "(a/b)*100"	\
	        -prefix "$subj"_"$epi"_ns_norm

		if ("$epi" == EPI1) then
			3dBlurToFWHM -input "$subj"_"$epi"_ns_norm+orig \
				-blurmaster "$subj"_"$epi"_ns_norm+orig \
				-prefix "$subj"_"$epi"_ns_norm_blur+orig \
				-FWHMxy 4.4
		else
			3dBlurToFWHM -input "$subj"_"$epi"_ns_norm+orig \
				-blurmaster "$subj"_"$epi"_ns_norm+orig \
				-prefix "$subj"_"$epi"_ns_norm_blur+orig \
				-FWHMxy 3
		fi

		3dToutcount -range \
			-save "$subj"_"$epi"_prepro "$subj"_"$epi"_ns_norm_blur+orig | 1dplot -stdin -one -jpg "$subj"_"$epi"_Tout.jpg

		# melodic to check IC quality

		3dAFNItoNIFTI "$subj"_"$epi"_ns_norm_blur+orig*
		3dAFNItoNIFTI "$subj"_"$epi"_mean+orig*

		gzip "$subj"_"$epi"_volreg+orig*
		gzip "$subj"_"$epi"_volreg_despike+orig*
		gzip "$subj"_"$epi"_BrainMask+orig*
		gzip "$subj"_"$epi"_ns+orig*
		gzip "$subj"_"$epi"_ns_norm+orig*
		gzip "$subj"_"$epi"_ns_norm_blur+orig*

		# rm -rf "$subj"_"$epi"_ns_norm_blur.ica

		if ("$epi" == EPI1) then
			melodic -i "$subj"_"$epi"_ns_norm_blur.nii \
				--nomask \
				--nobet \
				--tr=1 \
				--report \
				-d 30 \
				--bgimage="$subj"_"$epi"_mean.nii -v
		else 
			melodic -i "$subj"_"$epi"_ns_norm_blur.nii \
				--nomask \
				--nobet \
				--tr=2 \
				--report \
				-d 30 \
				--bgimage="$subj"_"$epi"_mean.nii -v
		fi
	done
done
