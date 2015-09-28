#!/bin/sh

#Kids_resting-state

i_subj=$1   # prefix of output BRIKS (should be 1, 2, 3, ...)

num_subj=$

nvolume=177 #num of volumes per run without 1st dummy vols
nrefslice=1 #reference slice for slice time correction (3dTshift) 
			#(when even number of slices is collected the scanner starts at slice 2)

fw=6.0 #smoothing filter width

proj_path=~/data/RestingStateKids


for i_subj in $*
do

cd "$proj_path"/CER"$i_subj"

# convert MP to nifti
echo "*** Converting MP to nifti ***"
3dAFNItoNIFTI -prefix subj"$i_subj"_MP \
	subj"$i_subj"_MP+orig

# skull stripping with SPM
echo "*** Skull stripping MP ***"
../spm_ss_final subj"$i_subj"_MP.nii

# convert MP to BRIK
echo "*** Converting MP to BRIK ***"
3dcopy subj"$i_subj"_MP.ns.nii \
	subj"$i_subj"_MP_ns+orig.BRIK

# slice time correction
echo "*** Slice time correction ***"
3dTshift -slice "$nrefslice" \
	-tpattern alt+z2 \
	-prefix subj"$i_subj"_EP_T \
	subj"$i_subj"_EP+orig

# motion correction
echo "*** Motion correction ***"
3dvolreg -twopass \
	-base subj"$i_subj"_EP+orig'[0]' \
	-dfile subj"$i_subj"_MoPar.txt \
	-prefix subj"$i_subj"_EP_TR subj"$i_subj"_EP_T+orig

# normalizing
echo "*** Normalizing ***"
echo "*** Step 1 ***"
3dWarp -card2oblique subj"$i_subj"_EP+orig \
	-prefix subj"$i_subj"_MP_ns_algntoEP \
	subj"$i_subj"_MP_ns+orig

echo "*** Step 2 ***"
@Align_Centers -base ../MNI_kids_ss_2+tlrc.BRIK \
	-dset subj"$i_subj"_MP_ns_algntoEP+orig.BRIK \
	-cm \
	-child subj"$i_subj"_EP_TR+orig

echo "*** Step 3 ***"
align_epi_anat.py -epi subj"$i_subj"_EP_TR_shft+orig \
	-anat subj"$i_subj"_MP_ns_algntoEP_shft+orig -epi_base 0 \
	-anat_has_skull no \
	-prep_off \
	-giant_move

echo "*** Step 4 ***"
@auto_tlrc -ok_notice \
	-no_ss \
	-dxyz 1 \
	-suffix _MNI \
	-base ../MNI_kids_ss_2+tlrc.BRIK \
	-input subj"$i_subj"_MP_ns_algntoEP_shft_al+orig.BRIK

echo "*** Step 5 ***"
@auto_tlrc -dxyz 3 \
	-suffix N -pad_input 62 \
	-apar subj"$i_subj"_MP_ns_algntoEP_shft_al_MNI+tlrc.BRIK \
	-input subj"$i_subj"_EP_TR_shft+orig.BRIK

# spatial smoothing
echo "*** Spatial smoothing ***"
3dmerge -doall -1blur_fwhm "$fw" -prefix subj"$i_subj"_EP_TR_shftNS \
	subj"$i_subj"_EP_TR_shftN+tlrc.BRIK

# creating brain mask
echo "*** Creating brain mask ***"
3dAutomask -dilate 3 \
	-prefix subj"$i_subj"_EP_BrainMask subj"$i_subj"_EP_TR_shftNS+tlrc.BRIK

# intensity normalization
echo "*** Intensity normalization ***"
3dTstat -prefix subj"$i_subj"_EP_TR_shftNS_mean \
	subj"$i_subj"_EP_TR_shftNS+tlrc.
3dcalc \
	-a subj"$i_subj"_EP_TR_shftNS+tlrc. \
	-b subj"$i_subj"_EP_TR_shftNS_mean+tlrc. \
	-c subj"$i_subj"_EP_BrainMask+tlrc. \
	-expr "(a/b * 100) * c" \
	-prefix subj"$i_subj"_EP_TR_shftNSI

# temporal filtering + removing mean and linear trend
echo "*** Temporal filtering & detrending***"
3dFourier -prefix subj"$i_subj"_EP_TR_shftNSIB \
	-highpass 0.005 \
	-lowpass 0.1 \
	subj"$i_subj"_EP_TR_shftNSI+tlrc.BRIK

# extracting left and right amygdala, wm, ventricle, and whole brain (=global signal) time courses
echo "*** Extracting wm & csf time courses ***"
3dROIstats -mask ../mask_wm_resampled+tlrc \
	-quiet subj"$i_subj"_EP_TR_shftNSIB+tlrc > subj"$i_subj"_TimeCourse_wm.txt

3dROIstats -mask ../mask_csf_resampled+tlrc \
	-quiet subj"$i_subj"_EP_TR_shftNSIB+tlrc > subj"$i_subj"_TimeCourse_csf.txt

# regressing out nuisance signals
echo "*** Regressing out wm signal, csf signal & motion parameters ***"
3dDeconvolve \
	-input subj"$i_subj"_EP_TR_shftNSIB+tlrc \
	-mask subj"$i_subj"_EP_BrainMask+tlrc \
	-polort -1 \
	-nobout \
	-local_times \
	-num_stimts 8 \
	-stim_file 1 subj"$i_subj"_TimeCourse_wm.txt -stim_base 1 -stim_label 1 wm \
	-stim_file 2 subj"$i_subj"_TimeCourse_csf.txt -stim_base 2 -stim_label 2 csf \
	-stim_file 3 ./subj"$i_subj"_MoPar.txt'[1]' -stim_base 3 -stim_label 3 roll \
	-stim_file 4 ./subj"$i_subj"_MoPar.txt'[2]' -stim_base 4 -stim_label 4 pitch \
	-stim_file 5 ./subj"$i_subj"_MoPar.txt'[3]' -stim_base 5 -stim_label 5 yaw \
	-stim_file 6 ./subj"$i_subj"_MoPar.txt'[4]' -stim_base 6 -stim_label 6 dS \
	-stim_file 7 ./subj"$i_subj"_MoPar.txt'[5]' -stim_base 7 -stim_label 7 dL \
	-stim_file 8 ./subj"$i_subj"_MoPar.txt'[6]' -stim_base 8 -stim_label 8 dP \
	-errts subj"$i_subj"_EP_TR_shftNSIB_errts \
	-tout \
	-fout \
	-bucket ./subj"$i_subj"_EP_TR_shftNSIB_Deconv_wm_vent_mot
done