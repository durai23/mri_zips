function [simresult,opts] = set_guidata_beta(handles)
%Set values in the Betas_play gui
%
% Syntax :
%    [simresult,opts] = set_guidata_beta(handles)
%
% Button to load experiment from Configuration File
%
% Input Parameters:
%     
%       handles           :  structure of handles. The same that GUIs use
%
% Output Parameters:
%  
%       opts              : Structure of options and settings
%       simresult         : Structure of results from the exp
%
%
% Related references:
%
%
% See also: createxmatrix_V2


% retrieve data
simresult = getappdata(0,'simresult');
opts      = getappdata(0,'opts');

% Set data
for i = 1: opts.iter
    sgn_names{i} = [num2str(i) '-   Signal_' num2str(i) ];
end

set(handles.listbox_signals,'String',sgn_names);                           % listbox_signals (signals)
set(handles.listbox_reg,'String', []);                                     % listbox_reg     (regressors)
set(handles.listbox_ref,'String', opts.regnames);                          % listbox_ref

set(handles.axes,'box','on');
set(handles.axes,'YtickLabel',[]);
grid on;

