% Example computation to parse k-means classification of clusters resulting from 
% probtrackx based segmentation.
%
% Syntax :
%
%
% Performs cluster assignment operations on the results of seeds-to-targets tractography
% based segmentation of the cingulum done with probtrackx. You can segment a region based 
% on the connectivity to a set of targets. Here cingulum was used as seed and 5 targets - 
% Amygdala, Hippocampus, Lateral Frontal, Precentral, Rostral Midde F, and Superior P. 
% Segmentation results were subjected to k-means classification in each subject. These 
% classification results are then compared across subjects. Segmentations in each 
% subject is compared to a selected subject and reassigned based on (minimization of 
% absolute error) these comparisons. Finally the probability that a segment was identified 
% consistently across subjects was calculated and plotted.
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

% Create cluster array objects for all subjects to store classification data
for sublist = {'101' '102' '104' '105' '106' '107' '108' '109' '110' '111'}
     base='~/bnst_data/WZP';
     base2='B/lcing_5/lcing5_';
     base3='/track';
     base4='s';
     base5='c';
     for clist = {'1' '2' '3' '4' '5'}
         ucmd3 = ['' base '' sublist{1} '' base2 '' clist{1} '' base3 ''];	% cd to results dir
         cd(ucmd3); 
%          !pwd
         samps=dlmread('samps.txt','\n');									% results of k-means stored in txt		
         tempy=strcat(base4,sublist{1},base5,clist{1});						% basic cluster var eg. s108c4 - subject 108 cluster 4
         tempx=genvarname(tempy);											% generate vars to hold results
         eval([tempx '={samps str2num(clist{1}) 0};']);						% basic cluster var assigned value from txt file
%          eval(['disp(' tempx ')'])
     end
 end
 % attempt cluster assignment in reference to subject 1
 for sublist = {'102' '104' '105' '106' '107' '108' '109' '110' '111'}
     base='~/bnst_data/WZP';
     base2='B/lcing_5/lcing5_';
     base3='/track';
     base4='s';
     base5='c';
     for clist = {'1' '2' '3' '4' '5'}
         ucmd3 = ['' base '' sublist{1} '' base2 '' clist{1} '' base3 ''];
         cd(ucmd3);															% cd to results dir
         sss={0 0 0 0 0};													% holds comparison errors
         for clist_101 = {'1' '2' '3' '4' '5'}
			 % keep previous loop term, i.e. clist, constant and loop 
			 % over clusters of subject 101 (clist_101) thus comparing
			 % cluster assignments of each subject with 101.
             tempy=strcat(base4,sublist{1},base5,clist{1});					
             tempu=strcat(base4,'101',base5,clist_101{1});	
             tempx=genvarname(tempy);										% make vars to access other subjects
             tempw=genvarname(tempu);										% make vars to access subject 101
			 % store results of comparisons in cell sss
             eval(['sss{str2num(clist_101{1})}=abs(' tempx '{1}(1)-' tempw '{1}(1))+abs(' tempx '{1}(2)-' tempw '{1}(2))+abs(' tempx '{1}(3)-' tempw '{1}(3))+abs(' tempx '{1}(4)-' tempw '{1}(4))+abs(' tempx '{1}(5)-' tempw '{1}(5))+abs(' tempx '{1}(6)-' tempw '{1}(6));']);
         end
         [smr,smc]=find(cell2mat(sss)==min(cell2mat(sss)));					% find row, col of the comparison with least error
         eval([tempx '{3}=smc;']);											% reassign cluster assignment for other subject	
         eval(['disp(' tempx ')']);
     end
 end
 % s101c1{3}=1;																% example generated vars with cluster assignment
 % s101c2{3}=2;																% at index 3
 % s101c3{3}=3;
 % s101c4{3}=4;
 % s101c5{3}=5;
 
% compute average cluster-target probabilities for 10 subjects
finclusts={'' '' '' '' ''};													% this holds the probability across subjects that 
																			% a cluster is a given segmentation
for x=1:5 
    tempa=strcat(base5,num2str(x));       									% generate cluster prob var
    tempb=genvarname(tempa);
    eval([tempb '= [0 0 0 0 0 0];']);
    eval(['size(' tempb ')']);
    for sublist = {'101' '102' '104' '105' '106' '107' '108' '109' '110' '111'}
        base4='s';
        base5='c';
        for clist = {'1' '2' '3' '4' '5'}
            % generate basic cluster var   
            tempy=strcat(base4,sublist{1},base5,clist{1});
            tempx=genvarname(tempy);
            eval(['size(transpose(' tempx '{1}))']);
            if eval([tempx '{3} == x'])
               eval([tempb '=' tempb '+transpose(' tempx '{1});']);
            end   
        end
    end
    eval(['finclusts{x} =' tempb '/10;']);									% average across 10 subjects
end 

%plot cluster maps for one segmentation at a time across 10 subjects
xnames={'Amygdala' 'Hippocampus' 'Lateral Frontal' 'Precentral' 'Rostral Midde F' 'Superior P'};
% subplot(2,3,1);
bar(finclusts{5});
title('Cluster 5')
ylim([0 200])
ylabel('Average Connectivity N=10')
set(gca,'FontSize',10)
%set(gca,'XTick',1:7)
set(gca,'XTickLabel',xnames)
rotateXLabels(gca(),40)
set(gca,'FontSize',10)
