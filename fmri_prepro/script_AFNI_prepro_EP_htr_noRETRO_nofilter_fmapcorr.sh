#!/bin/bash

#High Temporal Resolution Resting State

project_path=/home/owner/WIP/HTR-MB-fMRI/scripts/

#MNI Masks
mni_maskfolder=/home/owner/WIP/MNI_125_segmentation/
brain_mask="$mni_maskfolder"p0MNI152_T1_2mm_brain_mask.nii
csf_mask="$mni_maskfolder"p3MNI152_T1_2mm_csf_mask.nii
wm_mask="$mni_maskfolder"p2MNI152_T1_2mm_wm_mask.nii

N_Subj=$1   	#Number Of Subjects to be analyzed

nruns=2
				#nvolume=3194 #num of volumes per run without 1st dummy vols
nrefslice=24 	#reference slice for slice time correction (3dTshift) (when even number 
	            #of slices is collected the scanner starts at slice 2)

fw=5.0 			#smoothing filter width



for i_Subj in {1..6}
do

	for i_run in {1..2}
	do

		sub_path=/home/owner/WIP/HTR-MB-fMRI/Preproc_DATA/WZP00"$i_Subj"T/

		# EPI
		epi_path="$sub_path"DICOMs/proc_files/
		epi_brick="$epi_path"WZP00"$i_Subj"T_EP_run"$i_run"+orig

		# Anat
		anat="$sub_path"Nifti/02-WZP00"$i_Subj"T-t1_mpr_sag_p2_iso_0.9/
		structural="$anat"WZP00"$i_Subj"T-tfl3d1_ns-0001-0001-00192.nii
		betted_structural="$anat"WZP00"$i_Subj"T-tfl3d1_ns-0001-0001-00192_brain.nii

		# Field Mapping
		scanner=SIEMENS
		deltaTE=2.46
		dwelltime=0.0005

		if [ $i_run == 1 ]
		then
			# 2 images of magnitude
			magnitude_image1="$sub_path"Nifti/04-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0001-00001_brain.nii 
			magnitude_image2="$sub_path"Nifti/04-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0002-00001.nii 
			     phase_image="$sub_path"Nifti/05-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0002-00001.nii
		elif [ $i_run == 2 ] 
		then
		# 2 images of magnitude
			magnitude_image1="$sub_path"Nifti/07-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0001-00001_brain.nii 
			magnitude_image2="$sub_path"Nifti/07-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0002-00001.nii 
			     phase_image="$sub_path"Nifti/08-WZP00"$i_Subj"T-gre_field_mapping_mb_ft/WZP00"$i_Subj"T-fm2d2r-0001-0002-00001.nii
		fi

		cd $epi_path 
		echo "$epi_path"

		#Apply Retroicor (change for new one)
		#echo "*** Retroicor ***"
		#3dretroicor -ignore 0 \
			# -prefix WZP00"$i_Subj"T_EP_ret \
			# -card WZP00"$i_Subj"T_card1.1D \
			# -cardphase Subj"$i_Subj"cardPhase \
			# -resp WZP00"$i_Subj"T_resp1.1D \
			# -respphase Subj"$i_Subj"RespPhase \
			# -threshold .4 \
			# -order 2 \
			# WZP00"$i_Subj"T_EP_run2+orig. \
			# -overwrite
		echo "*** Slice time correction ***"
		# tpattern option must be used
 	    3dTshift -slice "$nrefslice" \
	 	    -prefix WZP00"$i_Subj"T_EP_run"$i_run"_T \
	 	    WZP00"$i_Subj"T_EP_run"$i_run"+orig \
	 	    -overwrite

		echo "*** Motion correction ***"
		3dvolreg -twopass \
			-base WZP00"$i_Subj"T_EP_run"$i_run"+orig'[0]' \
			-dfile WZP00"$i_Subj"T_MoPar_run"$i_run".txt \
			-prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR WZP00"$i_Subj"T_EP_run"$i_run"_T+orig \
			-overwrite

		echo "*** Converting BRIK to NIFTI ***"

		3dAFNItoNIFTI -prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR+orig \
			WZP00"$i_Subj"T_EP_run"$i_run"_TR+orig

		#Skull Stripping (BET,FSL)
		echo "*** Skull Stripping ***"

		bet WZP00"$i_Subj"T_EP_run"$i_run"_TR+orig.nii \
			WZP00"$i_Subj"T_EP_run"$i_run"_TRS+orig.nii \
			-f 0.5 \
			-F
		
		#Field Mapping Correction
		echo "*** Field Mapping Correction (FSL) ***"
		#fsl_prepare_fieldmap

		fsl_prepare_fieldmap "$scanner" \
			"$phase_image" \
			"$magnitude_image1" \
			Sub"$i_Subj"_run"$i_run"_field_map.nii.gz \
			"$deltaTE"

		#Fugue

		fugue --in=WZP00"$i_Subj"T_EP_run"$i_run"_TRS+orig.nii \
			--dwell="$dwelltime" \
			--loadfmap=Sub"$i_Subj"_run"$i_run"_field_map.nii.gz \
			-u \
			WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmap+orig.nii.gz

		#Normalization
		echo "*** Normalizing images (FSL)***"

		echo "Step 1"
		flirt -ref "$betted_structural" \
			-in WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmap+orig.nii.gz \
			-dof 7 \
			-omat func2struct_run"$i_run".mat

		echo "Step 2"
		flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain \
			-in "$betted_structural" \
			-omat my_affine_transf_run"$i_run".mat

		echo "Step 3"
		fnirt --in="$structural" \
			--aff=my_affine_transf_run"$i_run".mat \
			--cout=my_nonlinear_transf_run"$i_run" \
			--config=T1_2_MNI152_2mm

		echo "Appllying Warp"
		applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz \
			--in=WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmap+orig.nii.gz \
			--warp=my_nonlinear_transf_run"$i_run" \
			--premat=func2struct_run"$i_run".mat \
			--out=WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmapW+orig.nii.gz \
			--mask="$brain_mask"

		#spatial smoothing
		echo "*** Spatial smoothing ***"

		3dBlurToFWHM -input WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmapW+orig.nii.gz \
			-prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS \
			-mask "$brain_mask" \
			-FWHM "$fw"

		# 3dmerge -doall \
		# 	-1blur_fwhm "$fw" \
		# 	-prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS \
		# 	WZP00"$i_Subj"T_EP_run"$i_run"_TRSFmapW+orig.nii.gz \
		# 	-overwrite 

		#intensity normalization
		echo "*** Intensity normalization ***"
		3dTstat -prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS_mean \
			WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS+tlrc. \
		3dcalc \
			-a WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS+tlrc. \
			-b WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNS_mean+tlrc. \
			-c "$brain_mask" \
			-expr "(a/b * 100) * c" \
			-prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB -overwrite

		#temporal filtering + removing mean and linear trend

		# 3dBandpass -prefix WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB \
		# 	0.005 \
		# 	0.1 \
		# 	WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSI+tlrc.BRIK \
		# 	-mask "$brain_mask"

		#extracting left and right amygdala, wm, ventricle, and whole brain (=global signal) time courses
		echo "*** Extracting wm & csf time courses ***"
		3dresample -master WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB+tlrc \
			-inset "$wm_mask" \
			-prefix mask_wm_resampled_run"$i_run" \
			-overwrite
		3dresample -master WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB+tlrc \
			-inset "$csf_mask" \
			-prefix mask_csf_resampled_run"$i_run" \
			-overwrite

		3dROIstats -mask mask_wm_resampled_run"$i_run"+tlrc. \
			-quiet WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB+tlrc > WZP00"$i_Subj"T_TimeCourse_wm_run"$i_run".txt
		3dROIstats -mask mask_csf_resampled_run"$i_run"+tlrc. \
			-quiet WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB+tlrc > WZP00"$i_Subj"T_TimeCourse_csf_run"$i_run".txt

		#regressing out nuisance signals
		echo "*** Regressing out wm signal, csf signal & motion parameters ***"
		3dDeconvolve \
			-input WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB+tlrc \
			-mask "$brain_mask" \
			-polort -1 \
			-nobout \
			-local_times \
			-num_stimts 8 \
			-stim_file 1 WZP00"$i_Subj"T_TimeCourse_wm_run"$i_run".txt -stim_base 1 -stim_label 1 wm \
			-stim_file 2 WZP00"$i_Subj"T_TimeCourse_csf_run"$i_run".txt -stim_base 2 -stim_label 2 csf \
			-stim_file 3 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[0]' -stim_base 3 -stim_label 3 roll \
			-stim_file 4 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[1]' -stim_base 4 -stim_label 4 pitch \
			-stim_file 5 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[2]' -stim_base 5 -stim_label 5 yaw \
			-stim_file 6 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[3]' -stim_base 6 -stim_label 6 dS \
			-stim_file 7 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[4]' -stim_base 7 -stim_label 7 dL \
			-stim_file 8 ./WZP00"$i_Subj"T_MoPar_run"$i_run".txt'[5]' -stim_base 8 -stim_label 8 dP \
			-errts WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB_errts \
			-tout \
			-fout \
			-bucket ./WZP00"$i_Subj"T_EP_run"$i_run"_TR_shftNSIB_Deconv_wm_vent_mot
	done
done