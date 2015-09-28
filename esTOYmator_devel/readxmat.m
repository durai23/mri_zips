function  X = readxmat(filename)
%  Read and load from a file the design matrix
%
% Syntax :
%   X = readxmat(filename)
%
% Read the design matrix from the 'filename'.
%
% Input Parameters:
%     
%       filename          : Name of the file to be loaded
%
% Output Parameters:
%       
%       X                 : Design Matrix             
%
% Related references:
%
%
% See also: 


fid = fopen(filename);
tline = fgets(fid);
 i = 0;
while ischar(tline) 
    if tline(1) ~= '#' && ~isempty(str2num(tline))
        i = i + 1;
        X(i,:) = str2num(tline);
    end  
    tline = fgets(fid);
end

fclose(fid);