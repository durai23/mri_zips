function  pushbutton_plot_signals_mainfunc(hObject,handles)
%Plot the stimulus graph selected previously in Signal_PLUS
% 
% Syntax :
%   pushbutton_plot_signals_1(hObject,handles)
%
% Button to plot the stimulus graph selected previuosly in the Signal_PLUS.
% Depending on the selection, the Stimulus, the Stimulus Onset or the
% Stimulus convolved is plotted
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
% See also: PLOT_SIGNALS_STIMS , PLOT_SIGNALS_STIMS_CONV ,
% PLOT_SIGNALS_STIMS_ONSET


% 1- Get variables selected from listbox_reg
index_selected = get(handles.listbox_ref,'Value');
reg_list = get(handles.listbox_ref,'String');
sel_ref = reg_list{index_selected};

% 2- Get plot selected in popupmenu_selectplot
list_plot   = get(handles.popupmenu_selectplot_ref,'String');
index_plot  = get(handles.popupmenu_selectplot_ref,'Value');
plot_type =list_plot{index_plot};

% Check hold option of plots
if get(handles.radiobutton_hold_sg,'value')
    hold on;
else
    try
        handles = rmfield(handles,'iplot');
        handles = rmfield(handles,'legend');
    catch err
    end;
end

% Color Stuff
if ~isfield(handles,'c_cmap')
    handles.c_cmap = 1;
    guidata(hObject,handles);
end

% 3-  Then plot each case

switch plot_type
    case 'Select Plot'
        msgbox('Select Plot','Error');
        
    case 'Stimulus'
        htemp = plot_signals_stims(handles);

        
    case 'Stimulus Onset'
        htemp = plot_signals_stims_onset(handles,0);
     
                  
    case 'Stimulus Convolved'
        X = handles.opts.X;
        Xtemp = X(:,(end - handles.opts.num_stim) + 1: end) ;
        htemp = plot_signals_stims_conv(Xtemp,handles);
              
end

% Names to listbox plots
switch index_plot
    case 2
        name_plot = 'Stim';
    case 3
        name_plot = 'Stim_on';
    case 4
        name_plot = 'Stim_conv';
end

% Create field and update handles
if ~isfield(handles,'iplot')
    handles.iplot(1) = htemp;
    handles.legend{1} = [name_plot '_' sel_ref];
    set(handles.listbox_plots,'String',[name_plot '_' sel_ref]);
else
    count = length(handles.iplot) + 1;
    handles.iplot(count) = htemp;
    handles.legend{count} = [name_plot '_' sel_ref];
    lbox_plot = cellstr(get(handles.listbox_plots,'String'));
    lbox_plot{count} = [name_plot '_' sel_ref];
    set(handles.listbox_plots,'String',lbox_plot);
end
guidata(hObject,handles)

handles.c_cmap = handles.c_cmap + 1;
guidata(hObject,handles);