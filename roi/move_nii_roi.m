function moveROI(image,prefix,ds)
% Applies displacements specified in ds to the ROI in image.
%
% Syntax :
%   moveROI(image,prefix,ds)
%
%
% Applies displacements specified in ds to the ROI in image. Throws
% error if displacements exceed vol dimensions.
%
%
%
% Input Parameters:
%     
%       tract            :  path to ROI in nii
% 		prefix			 :  desired output name 	
% .		ds 				 :  [dx,dy,dz] vector of displacements		
%
% Output Parameters	  
%   
%
% Related references: 
%
%
% See also: 

dx = ds(1);
dy = ds(2);
dz = ds(3);

h = spm_vol(image);
V = spm_read_vols(h);

indx = find(V>0);
[xi,yi,zi]  = ind2sub(size(V),indx);

% Apply displacements
xi_m = xi + dx;
yi_m = yi + dy;
zi_m = zi + dz;

% Check if index are inside the box
[dim_x, dim_y, dim_z] = size(V);
% x
if logical(sum(xi_m > dim_x)) 
    error('Adjust your displacement in X');
end
% y
if logical(sum(yi_m > dim_y)) 
    error('Adjust your displacement in Y');
end
% z
if logical(sum(zi_m > dim_z)) 
    error('Adjust your displacement in Z');
end


Vm = zeros(size(V));
lindex = sub2ind(size(V), xi_m, yi_m,zi_m);
% Vm(xi_m,yi_m,zi_m) = 1;
Vm(lindex) = 1;

% Save
[path, ~ , ext]=fileparts(h.fname);
h.fname = [path prefix ext];
spm_write_vol(h,Vm);
