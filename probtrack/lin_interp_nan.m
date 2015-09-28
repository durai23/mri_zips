function Xnew = interpnan(X)
% replaces NaN's in a matrix with linear interpolation of surrounding elements
% 
%
% Syntax :
%		Xnew = interpnan(X)
%
%
% replaces NaN's in a matrix with linear interpolation of surrounding elements
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

n=size(X);
nx=n(1);
ny=n(2);
s=[1,1];
Xtemp=padarray(X,s,0,'both');
%disp(Xtemp)
for i = 1:nx+2
    for j = 1:ny+2
        if isnan(Xtemp(i,j))
            %fprintf('\nn\t%d\t%d\n',i,j);
            %Xtemp(i,j)
            elecount=0;
            sum=0;
            if Xtemp(i-1,j-1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i-1,j-1);end   
            if Xtemp(i-1,j) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i-1,j);end
            if Xtemp(i-1,j+1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i-1,j+1);end
            if Xtemp(i,j-1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i,j-1);end
            if Xtemp(i,j+1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i,j+1);end
            if Xtemp(i+1,j-1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i+1,j-1);end
            if Xtemp(i+1,j) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i+1,j);end
            if Xtemp(i+1,j+1) ~= 0;elecount=elecount+1;sum=sum+Xtemp(i+1,j+1);end        
            Xtemp(i,j)=sum/elecount;
        end
    end
end
%disp(Xtemp)
Xnew=Xtemp(1+s(1):end-s(1),1+s(2):end-s(2));