#!/bin/bash
#best warp configuration for bnst stuff
#input paths to subject T1 and skull stripped T1
mp=$(basename $1)
mp="${mp%%.*}"
d_mp=$(dirname $1)
mpns=$(basename $2)
mpns="${mpns%%.*}"
d_mpns=$(dirname $2)

echo T1                "$d_mp"/"$mp"
echo Skull stripped T1 "$d_mpns"/"$mpns"
date
echo Flirting.......12 mins

flirt -in "$d_mpns"/"$mpns".nii \
	-ref $FSL_DIR/data/standard/MNI152_T1_2mm_brain \
	-out "$d_mpns"/Flirted_"$mpns" \
	-omat "$d_mpns"/Flirted_"$mpns".mat \
	-bins 256 \
	-cost corratio \
	-searchrx -180 180 \
	-searchry -180 180 \
	-searchrz -180 180 \
	-dof 12  \
	-interp sinc \
	-sincwidth 7 \
	-sincwindow hanning

echo Fnirting.......20-40 mins

fnirt --in="$d_mp"/"$mp".nii \
	--aff="$d_mpns"/Flirted_"$mpns".mat \
	--config=FA_2_FMRIB58_1mm.cnf \
	--cout="$d_mp"/coef_"$mp"_to_MNI2mm \
	--iout="$d_mp"/Fnirted_"$mp" \
	--jout="$d_mp"/jac_"$mp"_to_MNI2mm 
	#--jacrange=0.1,10

echo making reverse warp....40-60 mins

invwarp --ref="$d_mp"/"$mp".nii --warp="$d_mp"/coef_"$mp"_to_MNI2mm.nii.gz --out="$d_mp"/coef_MNI2mm_to_"$mp"
