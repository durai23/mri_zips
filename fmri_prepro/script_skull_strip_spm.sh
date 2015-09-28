#!/bin/bash~/Desktop/MATLABtemp/spm8/sys

#
#
# skull stripping using SPM esp. in substandard T1
#
#
# spm_ss S02.anat.nii
# S02.anat.ns.nii will be produced

echo "++++++++Skull Stripping with SPM+++++++++++++"

# parse input
dir=$(dirname $1)
name=$(basename $1)
name=${name/%.nii/}

echo $dir
echo $name

export spmxj_anat=$dir/$name.nii
unset DISPLAY
matlab 2>&1 << EOF
addpath(genpath('/home/owner/Desktop/MATLABtemp/spm8/'));
	% initialize spm (otherwise nothing will work)
	spm fmri
	% grab important paths
	anat = getenv('spmxj_anat');
	%template_folder = [matlabroot '/toolbox/spm8/tpm/'];
	template_folder ='/home/owner/Desktop/MATLABtemp/spm8/tpm/';

	% batch structure for spm segmentation
	matlabbatch{1}.spm.spatial.preproc.data = {[anat ',1']};
	matlabbatch{1}.spm.spatial.preproc.output.GM = [0 0 1];
	matlabbatch{1}.spm.spatial.preproc.output.WM = [0 0 1];
	matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 0 1];
	matlabbatch{1}.spm.spatial.preproc.output.biascor = 1;
	matlabbatch{1}.spm.spatial.preproc.output.cleanup = 1;
	matlabbatch{1}.spm.spatial.preproc.opts.tpm = {
		                                           [template_folder 'grey.nii']
		                                           [template_folder 'white.nii']
		                                           [template_folder 'csf.nii']
		                                           };
	matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2
		                                             2
		                                             2
		                                             4];
	matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'mni';
	matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
	matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
	matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.001;
	matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 50;
	matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
	matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};

	% run the batch job
	spm_jobman('serial', matlabbatch);
EOF

echo "+++++++++++++++++Finished with SPM+++++++++++++++++++++++++"

# apply the brain mask
c1=$dir/c1$name.nii
c2=$dir/c2$name.nii
# c3 is csf, but it doesn't work well
#c3=$dir/c3$name.nii
echo "applying brain mask"
3dcalc -a "$spmxj_anat" -b "$c1" -c "$c2" -expr 'a*or(b,c)' -prefix "$dir"/"$name"_ns.nii
echo "done.."
unset spmxj_anat

