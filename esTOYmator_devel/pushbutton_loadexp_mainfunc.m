function  pushbutton_loadexp_mainfunc(hObject,handles)
%Load experiment structure (Exp Explorer)
%
% Syntax :
%   pushbutton_loadexp_mainfunc(hObject,handles)
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
% See also: createxmatrix_V2


% Load  Configuration File
[FileName,PathName,Ext]= uigetfile('*.mat');

try
    load([PathName FileName]);
    
    handles.timings = opts.handles.timings;
    
    set(handles.edit_loadexp,'String',[PathName filesep FileName Ext],'ForegroundColor',[0 0 0]);        % 1- edit Loadexp
    set(handles.text_loadexp,'String',FileName(1:end-16),'ForegroundColor',[0 0 0]);                     % 2- text Loadexp (length('_config_fil.mat') = 16)
    
    set(handles.edit_prefix,'String',FileName(1:end-16),'ForegroundColor',[0 0 0]);                      % 3- edit Loadexp
    set(handles.edit_TR,'String',opts.TR,'ForegroundColor',[0 0 0]);                                     % 4- edit Loadexp
    set(handles.edit_npoints,'String',opts.npts,'ForegroundColor',[0 0 0]);                              % 5- edit npoints
    set(handles.edit_num_stim,'String',opts.num_stim,'ForegroundColor',[0 0 0]);                         % 6- edit num_stim
    set(handles.edit_num_runs,'String',opts.num_runs,'ForegroundColor',[0 0 0]);                         % 7- edit num_runs
    set(handles.edit_snr,'String',opts.snr,'ForegroundColor',[0 0 0]);                                   % 8- edit snr
    
    % 9-  POLORT 
    list = {'None'; 'A'; '2'; '3'; '4'; '5'};
    
    if opts.polort_gen == -1
        set(handles.popupmenu_polort_gen,'Value',1);
    else
        polort = find(opts.opts.polort_gen==char(list));
        set(handles.popupmenu_polort_gen,'Value',polort);
    end
    
    % 10- HRFs
    handles.hrfs_gen_temp = opts.handles.hrfs_gen_temp;
    handles.stim_dur      = opts.handles.stim_dur;
    set(handles.popupmenu_hrf_sim,'Value',opts.hrf_gen_value);
    
    % 11-  HRFs Listbox
    regnames = opts.handles.regname;
    handles.regname = regnames;
    
    for i = 1:size(opts.handles.timings,1)
        hrflist_text{i} = [ regnames{i} '   ' opts.hrf_gen{i}];
    end
    set(handles.listbox_hrf,'String', hrflist_text)
    
    % 12- Betas uitable
    ncols = size(handles.timings,1);
    set(handles.uitable_beta, 'Data',opts.beta);
    set(handles.uitable_beta,'ColumnEditable',true(1,ncols))
    set(handles.uitable_beta,'ColumnName',regnames)
    
    % 13- Regressors Listbox
    regtemp = regnames;
    regtemp{end + 1} = 'All';
    set(handles.listbox_reg,'String',regtemp)
    
    handles.project_path = PathName;
    guidata(hObject,handles) ; 
    
    glbopts.project_path = PathName;
    
catch err
    return;
end