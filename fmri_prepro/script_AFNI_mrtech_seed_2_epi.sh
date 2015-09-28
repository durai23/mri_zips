#!/bin/bash
tap afni-new
subjlist=(WZP108B)
#define ROI here
roilist=(lBNST_EPI1_fractionize_05)
base="/export/data/mrtech/BNST/dra/"

#get the average time course within the seed region for each subj 

for subj in ${subjlist[*]}
do
    cd "$base"/"$subj"/

  	3dAFNItoNIFTI "$subj"_EPI1_RSFC_LFF+orig*

    #  rm -f "$subj"_LFF.nii
    #  ln -s "$base"/"$subj"_RSFC.nii ./

    rm -f "$subj"__EPI1_LFF_errts2.nii
    rm -f "$subj"_EPI1_LFF_buc.nii


    3dDeconvolve -input "$subj"_EPI1_RSFC_LFF.nii"[09-559]" \
      -polort A -jobs 3 -float \
      -goforit 4 \
      -errts "$subj"_EPI1_LFF_errts2.nii \
      -bucket "$subj"_EPI1_LFF_buc.nii
     
    rm -f "$subj"_EPI1_LFF_buc.nii  


    for roi in ${roilist[*]}
    do
          #  rm -f "$roi"_fractionize_065+orig*
          #  ln -s "$base"/masks/"$roi"_fractionize_065+orig.* ./
            rm -f "$subj"_EPI1_LFF_errts2_"$roi".1D
            3dmaskave -mask "$subj"_"$roi"+orig -quiet "$subj"_EPI1_LFF_errts2.nii \
            > "$subj"_EPI1_LFF_errts2_"$roi".1D

          echo "done .1D"
    done  
  # roi
done  
# subj
echo "done masking ROI"

for subj in "$subj"
do
   for roi in "$roi" 
   do
      rm -f "$subj"_EPI1_LFF_buc.nii
      rm -f "$subj"_EPI1_LFF_"$roi"_2ort.nii*
      rm -f "$subj"_EPI1_LFF_"$roi"_2ort-z.nii*
      
      3dDeconvolve -input "$subj"_EPI1_LFF_errts2.nii \
         -jobs 3 -float \
         -num_stimts 1 \
         -stim_file 1 "$subj"_EPI1_LFF_errts2_"$roi".1D \
         -stim_label 1 ""$subj"_EPI1_LFF_errts2_"$roi"" \
         -tout \
         -rout \
         -bucket "$subj"_EPI1_LFF_buc.nii

      3dcalc -a "$subj"_EPI1_LFF_buc.nii'[4]' \
          -b "$subj"_EPI1_LFF_buc.nii'[2]' \
          -expr "ispositive(b)*sqrt(a)-isnegative(b)*sqrt(a)" \
          -prefix "$subj"_EPI1_LFF_"$roi"_2ort.nii
      
      echo "done 3dDeconvolve"

      #cc to Z-score transform using fisher's z-transform
     
      3dcalc -a "$subj"_EPI1_LFF_"$roi"_2ort.nii \
        -expr "0.5*log((1+a)/(1-a))" \
        -datum float -prefix "$subj"_EPI1_LFF_"$roi"_2ort-z.nii

      rm -f "$subj"_EPI1_LFF_"$roi"_2ort.nii*
      rm -f *buc*
      rm -f "$subj"_EPI1_LFF_errts2_"$roi".1D
      
      rm -f "$subj"_EPI1_LFF_errts2.nii* 3dDecon*


  done
done 


