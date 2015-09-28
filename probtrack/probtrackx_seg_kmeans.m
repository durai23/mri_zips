% k-means classification of clusters resulting from probtrackx based segmentation.
%
% Syntax :
%
%
% Performs k-means classification on the results of seeds-to-targets tractography
% based segmentation of the cingulum done with probtrackx. You can segment a region based 
% on the connectivity to a set of targets. Here cingulum was used as seed and 5 targets - 
% Amygdala, Hippocampus, Lateral Frontal, Precentral, Rostral Midde F, and Superior P. 
% Segmentation results were subjected to k-means classification in each subject. 
% Connectivity matrix is cleaned and correlation coefficient matrix is computed on it,
% which is then further passed to the k-means function.
%
%
% Input Parameters:
%     
%
%
% Output Parameters:
%
% Related references: 
%
%
% See also:  
 for sublist = {'101' '102' '104' '105' '106' '107' '108' '109' '110' '111'}
   base='~/bnst_data/WZP';
   base2='B/lcing_5';
   
   k=5;    
   pth=strcat(base,sublist{1},base2);
%    fprintf('%s',pth);
   ucmd2 = ['' base '' sublist{1} '' base2 ''];
   fprintf('\npath is %s\n',ucmd2);
   cd(ucmd2);
   !pwd
   !ls | grep clust | xargs rm
   x=load('fdt_matrix2.dot');
   xx=spconvert(x);
   size(xx)
   M=full(xx);
   [ M, rmc ]=rmzercol(M);									% clean matrix
   [ M, rmr ]=rmzerrow(M);
   size(M)
%   cc=1+corrcoef(M');
   cc=corrcoef(M'); 								
   idx=kmeans(cc,k);
   addpath([getenv('FSLDIR') '/etc/matlab']);
   [mask,~,scales] = read_avw('fdt_paths');
   size(mask)
   mask = 0*mask;
   size(mask)
   coord = load('coords_for_fdt_matrix2')+1;
   coord=rmrow(coord,rmr);
   ind   = sub2ind(size(mask),coord(:,1),coord(:,2),coord(:,3));
   [~,~,j] = unique(idx);
   mask(ind) = j;
   save_avw(mask,'clusters015','i',scales);   
   !fslcpgeom fdt_paths clusters015
   clear;
 end
 