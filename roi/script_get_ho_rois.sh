#!/bin/bash
#will fetch HarvardOxford ROIs
#input path to T1 of subject 
mp=$(basename $1)
mp="${mp%%.*}"
d_mp=$(dirname $1)
mkdir "$d_mp"/rois
mkdir "$d_mp"/rois/cort
mkdir "$d_mp"/rois/sub
#cortical stuff
for i in {1..48}
do
	roi=$(sed '17,64!d' $FSL_DIR/data/atlases/HarvardOxford-Cortical.xml |	awk -F'">' '{gsub(/<.*/,"",$2);print $2;}' | awk "NR==$i")	\
	j=$(($i-1))
	fslroi $FSL_DIR/data/atlases/HarvardOxford/HarvardOxford-cort-prob-1mm.nii.gz "$d_mp"/rois/cort/"$roi" $j 1
	fslmaths "$d_mp"/rois/cort/"$roi".nii.gz -thr 50 -bin "$d_mp"/rois/cort/"$roi"_50
	rm "$d_mp"/rois/cort/"$roi".nii.gz
done
#subcortical stuff
for i in {1..21}
do
	roi=$(sed '17,37!d' $FSL_DIR/data/atlases/HarvardOxford-Subcortical.xml | awk -F'">' '{gsub(/<.*/,"",$2);print $2;}' | awk "NR==$i")	\
	j=$(($i-1))
	fslroi $FSL_DIR/data/atlases/HarvardOxford/HarvardOxford-cort-prob-1mm.nii.gz "$d_mp"/rois/sub/"$roi" $j 1
	fslmaths "$d_mp"/rois/sub/"$roi".nii.gz -thr 50 -bin "$d_mp"/rois/sub/"$roi"_50
	rm "$d_mp"/rois/sub/"$roi".nii.gz
done

	
	
