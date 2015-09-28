function bnstartend(ac_base,fx_end)
% Gives BNST_start and BNST_end slice locations, given AC_base and FX_end.
%
% Syntax :
%	bnstartend(ac_base,fx_end)	
%
% Gives BNST_start and BNST_end coronal slice location in any given T1 volume 
% opened in Slicer. Given AC_base (anterior commisure landmark on coronal) and 
% FX_end (fornix end landmark on coronal) this calculates an approximate coronal 
% slice location of the BNST start and end points. Polynomial fit  failed, and 
% using law of proportions gave a better result. 
%
%
% Input Parameters:
%     	ac_base				:	anterior commisure base in coronal 
%		fx_end				: 	fornix end in coronal 
%
% Output Parameters:
		
%
% Related references: 
%
%
% See also:  
% Date	:	11/14/2013

    mai_ac_base=0;
    mai_bn_start=-2.7;
    mai_bn_end=2.7;
    mai_fx_end=8.0;
    Dxw=(mai_ac_base-mai_bn_start)*(fx_end-ac_base)/8;
    Dzy=(mai_fx_end-mai_bn_end)*(fx_end-ac_base)/8;
    bn_start=ac_base-Dxw;
    bn_end=fx_end-Dzy;
    fprintf('\nBN starts in Slicer at %dmm and ends in Slicer at %dmm. Pad 1 slice to ensure coverage.\n',bn_start,bn_end);  
end
    
    