function [ Xnew, rmvc ] = rmzerrow(X)
% Removes all all-zero rows from matrix and returns indices
%
% Syntax :
%	[ Xnew, rmvc ] = rmzercol(X)	
%
% Removes all rows that sum to zero from (large) matrix, returns trimmed matrix 
% and deleted row indices. Progress bar included
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

Xnew=X;
h = waitbar(0,'...');
n=size(X);
nx=n(1);
ny=n(2);
rmvc=[];
for i=1:nx
    sm=0;
    for j=1:ny
        sm=sm+X(i,j);
    end
    if (sm == 0)
        rmvc=[rmvc i];
    end
end
n=size(rmvc);
nx=n(2);
l=0;
for k=1:nx
    Xnew(rmvc(k)-l,:)=[];
    fprintf('\nEmpty row %d of %d replaced',k,nx);
    perc=ceil((k/nx)*100);
    waitbar(perc,h,sprintf('%d%% done',perc)) 
    l=l+1;
end
close(h);
