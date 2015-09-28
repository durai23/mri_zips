function pushbutton_regadd_mainfunc(hObject,handles)
%Button to plot regressors and add it to the list in betas_play gui
% 
% Syntax :
%   pushbutton_regadd_mainfunc(hObject,handles)
%
% On click will plot the selcted regressors as well add it to the list 
% of regressors to be used in the betas_play gui
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
% See also: PLOT_SIGNALS_STIMS_CONV

% 1- Get variables selected from listbox_reg (list of availables regressors)
index_selected = get(handles.listbox_ref,'Value');
reg_list = get(handles.listbox_ref,'String');
sel_reg = reg_list{index_selected};

% % 2- Get plot selected in popupmenu_selectplot
% list_plot   = get(handles.popupmenu_selectplot_ref,'String');
% index_plot  = get(handles.popupmenu_selectplot_ref,'Value');
% plot_type =list_plot{index_plot};

% Check if c_cmap is a field and initialize it
if ~isfield(handles,'c_cmap')
    handles.c_cmap = 1;
    guidata(hObject,handles);
end

% 3-  Then plot 'Stimulus Convolved'


% 3.1-  Add selected Regressor to list box of Regressors
reg_list2 = get(handles.listbox_reg,'String');
if isempty(reg_list2)
    
    X = handles.opts.X;
    Xtemp = X(:,(end - handles.opts.num_stim) + 1: end) ;
    
    handles.betas_plot_hand = plot_signals_stims_conv(Xtemp,handles);
    handles.betas_reg = Xtemp(:,index_selected);
    handles.betas_color = handles.c_cmap;
    handles.betas_beta  = handles.opts.beta(index_selected);
    
    set(handles.slider_beta,'value',handles.opts.beta(index_selected));
    set(handles.edit_beta,'String', handles.opts.beta(index_selected));
    
    set(handles.listbox_reg,'String', sel_reg);
else
    % Check if exist before the selection
    for i = 1:size(reg_list2,1)
        exist_reg(i) = strcmp(reg_list2(i,:),sel_reg);
    end
    if sum(exist_reg) == 1
        return;
    else
        
        X = handles.opts.X;                                                                         % Get design mat
        Xtemp = X(:,(end - handles.opts.num_stim) + 1: end) ;
        handles.betas_plot_hand(size(reg_list2,1) + 1)   = plot_signals_stims_conv(Xtemp,handles);  % Plot Stim conv and get handle
        handles.betas_reg(:,size(reg_list2,1) + 1)       = Xtemp(:,index_selected);                 % Get selected Reg
        handles.betas_color(size(reg_list2,1) + 1)       = handles.c_cmap;                          % Get c_cmap
        handles.betas_beta(size(reg_list2,1) + 1)        = handles.opts.beta(index_selected);       % Get the Beta value
        
        count = size(reg_list2,1) + 1;                                     % Update counter
%         reg_listed = {reg_list2; sel_reg};
        reg_listed = cellstr(get(handles.listbox_reg,'String'));
        reg_listed{count} = sel_reg;
        set(handles.listbox_reg,'String', reg_listed);
        
    end
end
% Update handles
handles.c_cmap = handles.c_cmap + 1;
guidata(hObject,handles);