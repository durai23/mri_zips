function pushbutton_opentimings_mainfunc(hObject,handles )
%Open timings files and update fields in GUI (Exp Explorer)
%
% Syntax :
%   pushbutton_opentimings_mainfunc(hObject,handles)
%
% Buttom to load experiment from Configuration File
%
% Input Parameters:
%     
%       handles           :  structure of handles. The same that GUIs use
%
% Output Parameters:
%
%
% Related references:
%
%
% See also: 


% Open window to pick the timing files
[FileName,PathName,~]= uigetfile('*.1D;*.txt','MultiSelect', 'on');

%try
% global timings;% --------------------------------------------------------
if ~ischar(FileName)
%     timings = [repmat(PathName,size(FileName,2),1),char(FileName)];
    handles.timings = [repmat(PathName,size(FileName,2),1),char(FileName)];
else
%     timings = [PathName FileName];
    handles.timings = [PathName FileName];
end

% Get the name for each regressor from the timing file's name
 for i= 1:size(handles.timings,1)
     [~,reg{i},~] = fileparts(handles.timings(i,:));
 end
handles.regname = reg; 

% Update fields in the GUI (Exp Explorer)

% Load Exp Panel
set(handles.text_loadexp,'String', 'No exp loaded','ForegroundColor',[1 0 0]);       % text_loadexp (Prefix of the loaded exp)
set(handles.edit_loadexp,'String', '');                                              % edit_loadexp

% Exp Builder panel
set(handles.edit_prefix,'String', 'default_sim');                                    % edit_prefix   (Prefix of the loaded exp)
set(handles.edit_files,'String',[PathName filesep '...'],'ForegroundColor',[0 0 0]); % edit_files    (Path of the loaded files)
set(handles.edit_num_stim,'String', num2str(size(handles.timings,1)));               % edit_num_stim (number of stimulus)
set(handles.edit_TR,'String', '');                                                   % edit_TR       (number of stimulus)
set(handles.edit_npoints,'String', '');                                              % edit_npoints  (number of points in ime series/TRs)
set(handles.edit_num_runs,'String', '');                                             % edit_num_runs (number of runs. Not the number of runs in the tfiles, just the number of runs you want to model)
set(handles.edit_snr,'String', '');                                                  % edit_snr      (Signal to noise ratio of the simulated fmri signal)  

% POLORT  
set(handles.popupmenu_polort_gen,'Value', 1);

% HRF
set(handles.popupmenu_hrf_sim,'Value', 1);

% Betas uitable
ncols = size(handles.timings,1);
set(handles.uitable_beta, 'Data',ones(1,ncols));
set(handles.uitable_beta,'ColumnEditable',true(1,ncols))
set(handles.uitable_beta,'ColumnName',reg)
guidata(hObject,handles) ; 

% Regressors Listbox
regtemp = reg;
regtemp{end + 1} = 'All';
set(handles.listbox_reg,'String',regtemp)
set(handles.listbox_hrf,'String','No HRFs defined')

%catch err
%   return;
%end
%--------------------------------------------------------------------------


end

