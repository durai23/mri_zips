function varargout = betas_play(varargin)
% BETAS_PLAY MATLAB code for betas_play.fig
%      BETAS_PLAY, by itself, creates a new BETAS_PLAY or raises the existing
%      singleton*.
%
%      H = BETAS_PLAY returns the handle to a new BETAS_PLAY or the handle to
%      the existing singleton*.
%
%      BETAS_PLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BETAS_PLAY.M with the given input arguments.
%
%      BETAS_PLAY('Property','Value',...) creates a new BETAS_PLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before betas_play_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to betas_play_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help betas_play

% Last Modified by GUIDE v2.5 08-Apr-2014 19:58:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @betas_play_OpeningFcn, ...
                   'gui_OutputFcn',  @betas_play_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before betas_play is made visible.
function betas_play_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to betas_play (see VARARGIN)

% Choose default command line output for betas_play
handles.output = hObject;



% UIWAIT makes betas_play wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%**************************************************************************
%**************************************************************************
[handles.simresult,handles.opts] = set_guidata_beta(handles);
%**************************************************************************
%**************************************************************************

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = betas_play_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox_signals.
function listbox_signals_Callback(~, ~, handles)
% hObject    handle to listbox_signals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_signals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_signals

%**************************************************************************
%**************************************************************************
 if ~strcmp(get(gcf,'SelectionType'),'open')
    
     
    %Plot on click
    if get(handles.radiobutton_hold_sg,'value') 
        hold on;
    end
        
    sgn_i = get(handles.listbox_signals,'Value');
    htemp = plot(handles.simresult.signal_wn(:,sgn_i),'Color',[0.7,0.7,0.7]);
  
    plot_off = 0.0001;
%     legend(htemp,['Signals']);
    legend('boxoff');
    xlabel('TR');
    set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]);             % Setting the X limits
    set(gca,'YLim',[min(handles.simresult.signal_wn(:))+ plot_off*min(handles.simresult.signal_wn(:)) max(handles.simresult.signal_wn(:)) + plot_off*max(handles.simresult.signal_wn(:))]); % Setting the Y limits
    grid on;
    
    
    if get(handles.radiobutton_hold_sg,'value') 
        hold off;
    end
 end
%**************************************************************************
%**************************************************************************

% --- Executes during object creation, after setting all properties.
function listbox_signals_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox_signals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clearsgn.
function pushbutton_clearsgn_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_clearsgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
handles.c_cmap = 1;
if isfield(handles,'betas_reg')
    handles = rmfield(handles,'betas_reg');
end
if isfield(handles,'betas_plot_hand')
    handles = rmfield(handles,'betas_plot_hand');
end
set(handles.listbox_reg,'String', []);
set(handles.slider_beta,'value',0);
set(handles.edit_beta,'String', []);

guidata(hObject,handles);

% --- Executes on selection change in listbox_reg.
function listbox_reg_Callback(~, ~, handles)
% hObject    handle to listbox_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_reg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_reg

%**************************************************************************
%**************************************************************************
% Selection and Highlight

% index_selected = get(handles.listbox_reg,'Value');
% 
% if ~isfield(handles, 'select_plot_before')
%     handles.select_plot_before    = handles.iplot(index_selected);
%     handles.select_width_before   = get(handles.iplot(index_selected),'LineWidth'); 
%     
%     set(handles.iplot(index_selected),'LineWidth', 3);
%     uistack(handles.iplot(index_selected),'top');
% else
%     set(handles.select_plot_before ,'LineWidth', handles.select_width_before);
%     handles.select_plot_before    = handles.iplot(index_selected);
%     handles.select_width_before   = get(handles.iplot(index_selected),'LineWidth'); 
%     set(handles.iplot(index_selected),'LineWidth', 3);
%     uistack(handles.iplot(index_selected),'top');
% end
% 
% guidata(hObject,handles);



index_selected = get(handles.listbox_reg,'Value');
set(handles.slider_beta,'value',handles.betas_beta (index_selected))
set(handles.edit_beta,'String', handles.betas_beta (index_selected))
%**************************************************************************
%**************************************************************************

% --- Executes during object creation, after setting all properties.
function listbox_reg_CreateFcn(hObject, ~, ~)
% hObject    handle to listbox_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(~, ~, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************************************************************************
%**************************************************************************
% try  
push_button_plot_signals_2(handles);
% catch err
%     msgbox('Check your entries','Error');
%     return;
% end
%**************************************************************************
%**************************************************************************

% --- Executes on selection change in popupmenu_selectplot.
function popupmenu_selectplot_Callback(~, ~, ~)
% hObject    handle to popupmenu_selectplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selectplot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selectplot


% --- Executes during object creation, after setting all properties.
function popupmenu_selectplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clearreg.
function pushbutton_clearreg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearreg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton_clearreg.
function set_data(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearreg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_regadd.
function pushbutton_regadd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_regadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************************************************************************
%**************************************************************************
% try
if get(handles.radiobutton_hold_sg,'value')
    hold on;
end

pushbutton_regadd_mainfunc(hObject,handles);

if get(handles.radiobutton_hold_sg,'value')
    hold off;
end

% catch err
%     msgbox('Check your entries','Error');
%     return;
% end
%**************************************************************************
%**************************************************************************


% --- Executes on selection change in popupmenu_selectplot_ref.
function popupmenu_selectplot_ref_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectplot_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selectplot_ref contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selectplot_ref


% --- Executes during object creation, after setting all properties.
function popupmenu_selectplot_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectplot_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ref.
function listbox_ref_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ref contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ref


% --- Executes during object creation, after setting all properties.
function listbox_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_beta_Callback(hObject, eventdata, handles)
% hObject    handle to slider_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%**************************************************************************
%**************************************************************************
try
    slider_func(hObject,handles);
catch err
end;
%**************************************************************************
%**************************************************************************


% --- Executes during object creation, after setting all properties.
function slider_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_beta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beta as text
%        str2double(get(hObject,'String')) returns contents of edit_beta as a double


% --- Executes during object creation, after setting all properties.
function edit_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_ref.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_ref contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_ref


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_regadd.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_regadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_clearsgn.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearsgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_clearsgn.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearsgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
