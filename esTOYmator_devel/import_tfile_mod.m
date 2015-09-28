function stimulus_i = import_tfile_mod(filename,start_row,end_row)
%Read and load the files with the time of the stimuli
%
% Syntax :
%   import_tfile_mod(filename,start_row,end_row)
%
% Load files of stimuli
%
% Input Parameters:
%     
%       filename          : Name of the file
%       start_row         : Row to start reading from
%       end_row           : Row to end reading
%
% Output Parameters:
                  

% Load timing files
stimulus_temp = importdata(filename,'\t');

 % Parse by runs
for i = 1:size(stimulus_temp,1)
    n_stimsrow(i) = length(str2num(cell2mat(stimulus_temp(i,:))));
end

% Create matrix of zeros to embed the stimulus
stimulus_i = zeros(size(stimulus_temp,1),max(n_stimsrow));

% Embed stimulus
for i = 1:size(stimulus_temp,1)
    stimulus_i(i,1:n_stimsrow(i)) = str2num(cell2mat(stimulus_temp(i,:)));
end

% Just the output
stimulus_i = stimulus_i(start_row:end_row,:);
    


