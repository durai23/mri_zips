function [simresult,opts] = set_guidata_sgnplus(handles)
%Retrieve data from 'simulator' gui and set that data to the Signal_plus
%gui
% 
% Syntax :
%   pushbutton_sgn_est_mainfunc(hObject,handles)
%
% Button to plot estimated signal graph selected previuosly in Signal_PLUS.
% Depending on the selection each estimated regressor with its
% confidence interval can be plotted.
%
% Input Parameters:
%     
%       handles           :  structure of handles. The same that GUIs use
%
% Output Parameters:
%
%
%       simresult         : Structure withresults form simulation
%       opts              :  Structure with the settings and option of the
%       simulation and experiment
%
% Related references:
%
%
% See also: 


% Retrieve data
simresult = getappdata(0,'simresult');
opts      = getappdata(0,'opts');

% Set data
for i = 1: opts.iter
    sgn_names{i} = [num2str(i) '-   Signal_' num2str(i) ];
end

sgn_est_names{1} = 'Select Plot';
for i = 2: opts.num_stim + 1
    sgn_est_names{i} = [opts.regnames{i-1} ' (est)'];
end
sgn_est_names{i+1} = 'Signal (est)';


set(handles.listbox_signals,'String',sgn_names);                           %listbox_signals
set(handles.listbox_signals_est,'String',sgn_names);                       %listbox_signals
set(handles.listbox_ref,'String', opts.regnames);
set(handles.popupmenu_est,'String',sgn_est_names);
set(handles.listbox_plots,'String',[]);

set(handles.axes,'box','on');
set(handles.axes,'YtickLabel',[]);
grid on;

