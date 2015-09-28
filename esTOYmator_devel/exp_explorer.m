function varargout = exp_explorer(varargin)
% EXP_EXPLORER MATLAB code for exp_explorer.fig
%      EXP_EXPLORER, by itself, creates a new EXP_EXPLORER or raises the existing
%      singleton*.
%
%      H = EXP_EXPLORER returns the handle to a new EXP_EXPLORER or the handle to
%      the existing singleton*.
%
%      EXP_EXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXP_EXPLORER.M with the given input arguments.
%
%      EXP_EXPLORER('Property','Value',...) creates a new EXP_EXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp_explorer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp_explorer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp_explorer

% Last Modified by GUIDE v2.5 08-Apr-2014 23:38:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp_explorer_OpeningFcn, ...
                   'gui_OutputFcn',  @exp_explorer_OutputFcn, ...
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

% BEGIN MY initialization code - DO NOT EDIT
global glbopts;
glbopts.show_poly = 0;

% END MY initialization code - DO NOT EDIT


% --- Executes just before exp_explorer is made visible.
function exp_explorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp_explorer (see VARARGIN)

% Choose default command line output for exp_explorer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exp_explorer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exp_explorer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_files_Callback(hObject, eventdata, handles)
% hObject    handle to edit_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_files as text
%        str2double(get(hObject,'String')) returns contents of edit_files as a double

% --- Executes during object creation, after setting all properties.
function edit_TR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_opentimings_mainfunc(hObject,handles );


% %--------------------------------------------------------------------------
% [FileName,PathName,FilterIndex]= uigetfile('*.1D;*.txt','MultiSelect', 'on');
% 
% %try
% global timings;
% if ~ischar(FileName)
%     timings = [repmat(PathName,size(FileName,2),1),char(FileName)];
%     handles.timings = [repmat(PathName,size(FileName,2),1),char(FileName)];
% else
%     timings = [PathName FileName];
%     handles.timings = [PathName FileName];
% end
% 
% % Getting name for each REG
%  for i= 1:size(handles.timings,1)
%      [~,reg{i},~] = fileparts(handles.timings(i,:));
%  end
% handles.regname = reg;
% 
% set(handles.edit_files,'String',[PathName filesep '...'],'ForegroundColor',[0 0 0]);
% set(handles.edit_num_stim,'String', num2str(size(handles.timings,1)));
% 
% % Betas uitable
% ncols = size(handles.timings,1);
% set(handles.uitable_beta, 'Data',ones(1,ncols));
% set(handles.uitable_beta,'ColumnEditable',true(1,ncols))
% set(handles.uitable_beta,'ColumnName',reg)
% guidata(hObject,handles) ; 
% 
% % Regressors Listbox
% regtemp = reg;
% regtemp{end + 1} = 'All';
% set(handles.listbox_reg,'String',regtemp)
% set(handles.listbox_hrf,'String','No HRFs defined')
% 
% %catch err
% %   return;
% %end
% %--------------------------------------------------------------------------
function edit_TR_Callback(hObject, eventdata, handles)
% hObject    handle to text_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_TR as text
%        str2double(get(hObject,'String')) returns contents of text_TR as a double


% --- Executes during object creation, after setting all properties.
function text_TR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_num_stim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_num_stim as text
%        str2double(get(hObject,'String')) returns contents of edit_num_stim as a double


% --- Executes during object creation, after setting all properties.
function edit_num_stim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_num_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
save_confile(handles); %------------------------------------------------------------------------------------
catch err
    err_flag = msgbox('Check your entries','Error');
end


function edit_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_prefix as text
%        str2double(get(hObject,'String')) returns contents of edit_prefix as a double


% --- Executes during object creation, after setting all properties.
function edit_prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_num_runs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_num_runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_num_runs as text
%        str2double(get(hObject,'String')) returns contents of edit_num_runs as a double


% --- Executes during object creation, after setting all properties.
function edit_num_runs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_num_runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_npoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_npoints as text
%        str2double(get(hObject,'String')) returns contents of edit_npoints as a double


% --- Executes during object creation, after setting all properties.
function edit_npoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_polort_sim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_polort_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_polort_sim as text
%        str2double(get(hObject,'String')) returns contents of edit_polort_sim as a double


% --- Executes during object creation, after setting all properties.
function edit_polort_sim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_polort_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_hrf_sim.
function popupmenu_hrf_sim_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_hrf_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_hrf_sim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_hrf_sim

%---------------------------------------------------------------------------------------------------------------
% PUT TRY HERE
try
list   = get(handles.popupmenu_hrf_sim,'String');
index  = get(handles.popupmenu_hrf_sim,'Value');
hfr_sim =list{index};

regnames = handles.regname;

if index~=1
global optstemp;

optstemp.num_stim = str2num(get(handles.edit_num_stim, 'String'));
if ~isempty(optstemp.num_stim)
    try
        [handles.hrfs_gen_temp,handles.stim_dur]= input_multHRF_GUI(hfr_sim,regnames,handles);
        guidata(hObject,handles) ; 
        optstemp.hrfs_gen_temp = handles.hrfs_gen_temp;
        
        % HRFs Listbox 
        for i = 1:size(handles.timings,1)
            hrflist_text{i} = [ regnames{i} '   ' handles.hrfs_gen_temp{i}];
        end
        set(handles.listbox_hrf,'String', hrflist_text)
    catch err
        return;
    end
else
    msgbox('Select Stim. Classes','Warning !!!','Warn');
    set(handles.popupmenu_hrf_sim,'String', list);
    set(handles.popupmenu_hrf_sim,'Value', 1);
end
end
catch err
    msgbox('Check your entries','Error');
    return;
end

% --- Executes during object creation, after setting all properties.
function popupmenu_hrf_sim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_hrf_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_snr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_snr as text
%        str2double(get(hObject,'String')) returns contents of edit_snr as a double


% --- Executes during object creation, after setting all properties.
function edit_snr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_polort_gen.
function popupmenu_polort_gen_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_polort_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_polort_gen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_polort_gen

% list   = get(handles.popupmenu_hrf_sim,'String');
% index  = get(handles.popupmenu_hrf_sim,'Value');
% hfr_sim =list{index};
% 
% if index~=1
% %     config_file = get(handles.text_current_sim, 'String');
% %     load([glbopts.project_path filesep config_file(1,5:end)]);
% optstemp.num_stim = str2num(get(handles.edit_num_stim, 'String'));
% if optstemp.num_stim ~= []
%     optstemp.hrfs_est_temp = input_multHRF_GUI(optstemp,hfr_sim);
% %     save([opts.prefix '_config_file'], 'opts');
% end

% --- Executes during object creation, after setting all properties.
function popupmenu_polort_gen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_polort_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_selectplot.
function popupmenu_selectplot_Callback(hObject, eventdata, handles)
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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_reg.
function listbox_reg_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_reg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_reg


% --- Executes during object creation, after setting all properties.
function listbox_reg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    
push_button_plot_mainfunc_expv(handles);
catch err
    msgbox('Check your entries','Error');
    return;
end

% --- Executes on button press in pushbutton_report.
function pushbutton_report_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_loadexp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loadexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loadexp as text
%        str2double(get(hObject,'String')) returns contents of edit_loadexp as a double


% --- Executes during object creation, after setting all properties.
function edit_loadexp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loadexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadexp.
function pushbutton_loadexp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_loadexp_mainfunc(hObject,handles);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2

imshow('webglobe.gif');
% % imshow('header-um-logo.gif');
% imshow('logo.jpg');

% --- Executes on selection change in listbox_hrf.
function listbox_hrf_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_hrf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_hrf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_hrf


% --- Executes during object creation, after setting all properties.
function listbox_hrf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_hrf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes during object creation, after setting all properties.
% function axis2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to axes2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simulator;


% % --- Executes during object creation, after setting all properties.
% function axes2_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to axes2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: place code in OpeningFcn to populate axes2
