% Performs an example mean seed structural connectivity calculation to s
% subcortical and cortical masks by hemisphere in all subjects.
%
% Syntax :
%   
% Gets region names by opening a subject's mask name file, by hemisphere by 
% cortex/subcortex and calculates mean connectivity to subcortical and \
% cortical masks by hemisphere in all subjects. Calculates group results.
% Plots example bar plot of mean structural connectivity.
%
%
% Input Parameters:
%     
%     
% Output Parameters:
%
% Related references: 
%
%
% See also: 
% Date	:	3/13/2014
base1='seeds_to_WZP';
base2='B_70_';
base3='_';
base4='_names.txt';
base5='names'
base6='_means.txt';
base7='means'
nsubj=4;
% get region names by opening a subject's mask name file, by hemisphere by cortex/subcortex
for i = {'sub','cort'}
	for j = {'l','r'}
		fid=fopen(strcat(base1,'102',base2,j{1},base3,i{1},base4),'r');
		tempx=genvarname(strcat(j{1},i{1},base5));
		eval([tempx '=textscan(fid,''%s'',''delimiter'',''\n'');']);
	end
end
% calculate means to subcortical and cortical masks by hemisphere in all subjects
for i = {'l','r'}
	for j = {'sub','cort'}
		for k = {'102','107','108','109'}
			tempx=genvarname(strcat(i{1},j{1},base7,k{1}));
			eval([tempx '=dlmread(strcat(base1,k{1},base2,i{1},base3,j{1},base6));']);
		end
	end
end
%calculate group results
for i = {'l','r'}
	for j = {'sub','cort'}
		tempx=genvarname(strcat(i{1},j{1}));
		for k = {'102','107','108','109'}
			tempy=genvarname(strcat(i{1},j{1},base7,k{1}));
			eval([tempx '= tempx + (tempy)/nsubj;']);
		end
	end
end
% bar plot of mean structural connectivity
lcortnames{1}
bar(lsub);
title('L SUBCORTICAL')
ylim([0 3000])
ylabel('Classified Connectivity')
set(gca,'FontSize',20)
set(gca,'XTick',1:7)
set(gca,'XTickLabel',lsubnames{1})
rotateXLabels(gca(),90)
set(gca,'FontSize',10)