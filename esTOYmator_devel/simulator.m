function varargout = simulator(varargin)
% SIMULATOR MATLAB code for simulator.fig
%      SIMULATOR, by itself, creates a new SIMULATOR or raises the existing
%      singleton*.
%
%      H = SIMULATOR returns the handle to a new SIMULATOR or the handle to
%      the existing singleton*.
%
%      SIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATOR.M with the given input arguments.
%
%      SIMULATOR('Property','Value',...) creates a new SIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulator

% Last Modified by GUIDE v2.5 11-Apr-2014 01:48:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @simulator_OutputFcn, ...
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


% --- Executes just before simulator is made visible.
function simulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulator (see VARARGIN)

% Choose default command line output for simulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
    push_button_plot_mainfunc_simulator(handles)
    
catch err
    msgbox('Check your entries','Error');
    return;
end

% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    pushbutton_save_mainfunc(handles);
catch err
    msgbox('Check your entries','Error');
    return;
end

function edit_iter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_iter as text
%        str2double(get(hObject,'String')) returns contents of edit_iter as a double


% --- Executes during object creation, after setting all properties.
function edit_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_hrf_est.
function popupmenu_hrf_est_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_hrf_est (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_hrf_est contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_hrf_est

%---------------------------------------------------------------------------------------------------------------
% PUT TRY HERE

list   = get(handles.popupmenu_hrf_est,'String');
index  = get(handles.popupmenu_hrf_est,'Value');
hfr_est =list{index};

if index~=1
    %global optstemp;
    
    %optstemp.num_stim = str2num(get(handles.edit_num_stim, 'String'));
    if isfield(handles,'num_stim')
        if ~isempty(handles.num_stim)
            try
                regnames = handles.regname;
                [handles.hrfs_est,~]= input_multHRF_GUI(hfr_est,regnames,handles);
                guidata(hObject,handles) ;
                %optstemp.hrfs_gen_temp = input_multHRF_GUI(optstemp,hfr_sim,regnames,handles); % Looking for delete this in a future
                %optstemp.hrfs_gen_temp = handles.hrfs_gen_temp;
                
                % HRFs Listbox
                for i = 1:size(handles.timings,1)
                    hrflist_temp{i} = [ regnames{i} '   ' handles.hrfs_est{i}];
                end
                
                hrflist_text    = cell(1,length(hrflist_temp) + 1);
                hrflist_text{1} = 'All';
                hrflist_text(2:end) = hrflist_temp;
                
                %hrflist_text{end+1} = 'All';
                set(handles.listbox_hrf,'String', hrflist_text)
                
            catch err
                return;
            end
        else
            msgbox('Load Simulation First','Error');
        end
    end
end


% --- Executes during object creation, after setting all properties.
function popupmenu_hrf_est_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_hrf_est (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_polort_est.
function popupmenu_polort_est_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_polort_est (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_polort_est contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_polort_est


% --- Executes during object creation, after setting all properties.
function popupmenu_polort_est_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_polort_est (see GCBO)
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



function edit_loadsim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_loadsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_loadsim as text
%        str2double(get(hObject,'String')) returns contents of edit_loadsim as a double


% --- Executes during object creation, after setting all properties.
function edit_loadsim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_loadsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.                             LOAD SIMULATIONS
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton_loadsim_mainfunc(hObject,handles);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    pushbutton_runsim_mainfunc(hObject,handles);
    
catch err
    msgbox('Check your entries','Error');
    return;
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
imshow('webglobe.gif');


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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exp_explorer;
