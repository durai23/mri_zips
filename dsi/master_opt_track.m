function [] = master_opt_track(tract,subject,repno,hemi,startfa,endfa,nsamp)
% Master optimization script for all tracts for repeat datasets by subject by hemisphere
%
% Syntax :
%   master_opt_track(tract,subject,repno,hemi,startfa,endfa,nsamp)
%
% Calls dsi-studio with set tracking parameters and provided tract details.
% Generates tracts at each sampling point over range. For example if nsamp=50, 50
% tracts are generated serially and all tracts' stats are stored in a mat file.
% A plot is generated in the end to check noise over FA range manually.
%
% follow below ROI naming convention
% seed=hemi+tract+b.nii.gz
% end=hemi+tract.nii.gz
% roa=hemi+tract+roa.nii.gz
%
% Input Parameters:
%     
%       tract            :  [cing,ifo,csp,arc,fmj]	- name of tract to optimize
%       subject          :  ['3','4','5','9','10']	- subject ID
%       repno            :  ['1','2','3','4']		- repeat number
%       hemi             :  [l,r]					- hemisphere
%       startfa          :  [0.03,0.12]					- start value of FA range over which 
%													  	optimization occurs
%       endfa            :  [0.03,0.12] and > startfa   - end value of FA range over which 
%													  	optimization occurs
%       nsamp            :  [1,<50]
%
% Output Parameters:
%
% Related references: 
%
%
% See also: 

% set default tracking params
seedcount=100000;
turning_angle=60;
step_size=1;
smoothing=0.8;
min_len=20;
max_len=1000;
metrics={'count','len','lensd','vol','qa','qasd','gfa','gfasd','iso','isosd','xax'};

% set subject prefix
switch subject
	case '3'
		subj_prefix='T000';
	case {'4','5','9'}
		subj_prefix='WZP00';
	case {'10'}
		subj_prefix='WZP0';
	otherwise
		fprintf('\nnon-existent subject');		
		return;
end

% calculate x-axis intervals
xint=(endfa-startfa)/(nsamp-1);
colm=1;

% init vectors to store tract metrics 
for i = metrics
	tempx=genvarname(strcat('y',i{1}));
	eval([tempx '=zeros(1,nsamp);']);
end
counter1=1;

% each instance of this loop a track is generated as a function of the FA value constrained by rois
for i=startfa:xint:endfa
	op=strcat('output',num2str(counter1));
	str_temp = ['dsi_studio --action=trk --source=' subj_prefix '' subject '_' repno '.src.gz.odf8.f20.hs.gqi.1.25.fib.gz --initial_dir=0 --interpolation=0 --thread_count=8 --seed=' hemi '' tract 'b.nii.gz --end=' hemi '' tract '.nii.gz --roa=' hemi ''  tract 'roa.nii.gz --seed_count=' num2str(seedcount) ' --threshold_index=nqa --fa_threshold=' num2str(i) ' --turning_angle=' num2str(turning_angle) ' --step_size=' num2str(step_size) ' --smoothing= ' num2str(smoothing) ' --min_length=' num2str(min_len) ' --max_length= ' num2str(max_len) ' --output=' op ' --export=stat'];
	fprintf('\nFA value	:	%d\n',xval);
	
	% call dsi-studio
	dos(str_temp);    
	
	% create stats text file for tract at given FA value
	fnm=strcat(op,'.stat.txt');
	mcell=dlmread(fnm,'\t',[0,1,9,1]);		
	
	% get individual metrics out of stats cell at given FA value
	counter=1;
	if exist(fnm,'file')==2
		for j = metrics
			if j{1}=='xax'
				tempx=genvarname(strcat('y',j{1}));
				eval([tempx '(1,colm)=i;']);
			else				
				tempx=genvarname(strcat('y',j{1}));
				eval([tempx '(1,colm)=mcell(counter);']);
				counter=counter+1;
			end
		end
		colm=colm+1;
	else
		fprintf('\ntract %d not found or not ready',counter1);
	end
	counter1=counter1+1;
end
% save tract metrics to mat files
save('C:\Users\dra\Desktop\fibdata\matfiles\' tract '\' hemi '' tract '' subject '' repno '.mat','ycount','yvol','ylen','ylensd','yqa','yqasd','ygfa','ygfasd','xax');

% plot over all FA values for manual inspection
plot(xax,ycount,'k');
hold all;
plot(xax,ylen*80,'k--');
hold all;
plot(xax,yvol*1.7/10,'k:');
hold all;
plot(xax,yqa*50000,'k-.');
% plot(xax,ycount,'b-');
% plot(xax,ygfa,'g-');
% title('blue-box    red-ball');
% xlabel('nQA threshold');
% ylabel('Tract count');
fprintf('\nCOV	:	%d\n',std(ycount)/mean(ycount));	
end	