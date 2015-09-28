function qwx = get_mat_vars(tract)
% Loads mat files and loads vars with fiber metrics into a struct
%
% Syntax :
%   qwx = get_mat_vars(tract)
%
% Takes tract acronym and fetches all available mat files for all subjects 
% for both hemispheres for the specified tract. Data in mat files is 
% transferred to a strcut. This struct may be used to access stats of 
% all tractography performed for the specified tract.
%
%
% Input Parameters:
%     
%       tract            :  [cing,ifo,csp,arc,fmj]
%
% Output Parameters	  
%   
%		qwx				 :	Struct with track stats	
%
% Related references: 
%
%
% See also: 

tractup=upper(tract);
subjarray=['t' '4' '5' '9'];
orientarray=['L' 'R'];
counter=0;
%     qwx=struct([]);
for subj=subjarray
    for orient=orientarray
        for dset=1:4
            temppath=strcat('C:\Users\dra\Desktop\fibdata\matfiles\',tractup,'\',orient,tract,subj,num2str(dset),'.mat');
            if exist(temppath,'file')==2
                qwx.(genvarname([strcat(orient,subj,num2str(dset))])) = matfile(temppath);
            else
                fprintf('\nfile\t%s\t not found\n', strcat(orient,tract,subj,num2str(dset),'.mat'));
            end
            counter=counter+1;
        end
    end
end

% get fieldnames from any tract
f=fieldnames(qwx.Lt1);

% Interpolate missing scan for subject_5
if exist('C:\Users\dra\Desktop\fibdata\matfiles\IFO\Lifo53.mat','file')==2
    fprintf('\nFound Lauren!\n');
    for fv=2:10
        qwx.L54.(genvarname([f{fv}]))= (qwx.L51.(genvarname([f{fv}]))+qwx.L52.(genvarname([f{fv}]))+qwx.L53.(genvarname([f{fv}])))/3;
        qwx.R54.(genvarname([f{fv}]))= (qwx.R51.(genvarname([f{fv}]))+qwx.R52.(genvarname([f{fv}]))+qwx.R53.(genvarname([f{fv}])))/3;
    end
end
fprintf('\nTract stats of\t%s\t loaded!\n',tractup);
end


