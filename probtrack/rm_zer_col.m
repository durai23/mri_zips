function [ Xnew, rmvc ] = rmzercol(X)
% Removes all all-zero columns from matrix and returns indices
%
% Syntax :
%	[ Xnew, rmvc ] = rmzercol(X)	
%
% Removes all cols that sum to zero from (large) matrix, returns trimmed matrix 
% and deleted column indices. Progress bar included
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
for i=1:ny
    sm=0;
    for j=1:nx
        sm=sm+X(j,i);
    end
    if (sm == 0)
        rmvc=[rmvc i];
    end
end
n=size(rmvc);
ny=n(2);
l=0;
for k=1:ny
    Xnew(:,rmvc(k)-l)=[];
    fprintf('\nEmpty column %d of %d replaced',k,ny);
    perc=ceil((k/ny)*100);
    waitbar(perc,h,sprintf('%d%% done',perc)) 
    l=l+1;
end
close(h);



        