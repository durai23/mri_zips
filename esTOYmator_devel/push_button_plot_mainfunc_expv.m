function push_button_plot_mainfunc_expv(handles)
%Button to plot selection at the Exp explorer
%
% Syntax :
%   push_button_plot_mainfunc_expv(handles)
%
% Functions associated with the buttom to plot differents options
%
% Input Parameters:
%     
%       handles          : Structure of handles. The same that GUIs use
%
% Output Parameters:
%                   
%
% Related references: createxmatrix_V2 , plot_designmat_V2 , plot_regcorr_V2
% , plot_stims , plot_stims_conv , plot_stims_onset , plot_stimsconv_stims


% 1- Get variables selected from listbox_reg
% index_selected = get(handles.listbox_reg,'Value');
% reg_list = get(handles.listbox_reg,'String');
% sel_reg = reg_list{index_selected};

% 2- get plot selected in popupmenu_selectplot
list_plot   = get(handles.popupmenu_selectplot,'String');
index_plot  = get(handles.popupmenu_selectplot,'Value');
plot_type =list_plot{index_plot};

% 3-  Then plot each case

switch plot_type
    case 'Select Plot'
        msgbox('Select Plot','Error');
        
    case 'Stim.'
        plot_stims(handles);
        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Stimulus') %select the name you want
        
    case 'Stim. Onset'
        plot_stims_onset(handles);
        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Stimulus Onset') %select the name you want        
        
%     case 'HRFs'
%           msgbox('Not Available.... yet','Error');
          
    case 'Stim. Convolved'
        X     = createxmatrix_V2(handles);
        Xtemp = X(:,(end - str2num(get(handles.edit_num_stim,'String'))) + 1: end) ;
        plot_stims_conv(Xtemp,handles);
        
        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Stim. Convolved') %select the name you want          
     
    case 'Stim. Conv+Stim'
         X = createxmatrix_V2(handles);
         Xtemp = X(:,(end - str2num(get(handles.edit_num_stim,'String'))) + 1: end) ;
         plot_stimsconv_stims(Xtemp,handles);    
 
        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Stim Conv+ Stim') %select the name you want          
  
    case 'Design Matrix'
        X = createxmatrix_V2(handles);
        plot_designmat_V2(X,handles);

        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Design Matrix') %select the name you want           
        
    case 'Correlation Matrix'
        X = createxmatrix_V2(handles);
        plot_regcorr_V2(X,handles);

        set(gcf,'NumberTitle','off') %don't show the figure number
        set(gcf,'Name','Correlation Matrix') %select the name you want  


end

