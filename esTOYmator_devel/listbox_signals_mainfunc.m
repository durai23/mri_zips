function listbox_signals_mainfunc(hObject, handles)
% Function for the listbox_signals in the Signal_PLUS
%
% Syntax :
%   listbox_signals_mainfunc(hObject, handles)
%
% This function plots a vector of the signal when you click onto
% the name in the list.
%
% Input Parameters:
%     
%       handles           :  structure of handles. The same that GUIs use
%       hObject
%
% Output Parameters:
%
%
% Related references:
%
%
% See also:


 if ~strcmp(get(gcf,'SelectionType'),'open')
    
    %Plot on click
    if get(handles.radiobutton_hold_sg,'value') 
        hold on;
    else
        try
            handles = rmfield(handles,'iplot');
            handles = rmfield(handles,'legend');
        catch err
        end;
    end
        
    sgn_i = get(handles.listbox_signals,'Value');
    set(handles.listbox_signals_est,'Value',sgn_i);
    htemp = plot(handles.simresult.signal_wn(:,sgn_i),'Color',[0.7,0.7,0.7]);
    
    % Creating field and updating handles
    if ~isfield(handles,'iplot')
        handles.iplot(1) = htemp;
        handles.legend{1} = ['Signal_' num2str(sgn_i)];
        set(handles.listbox_plots,'String',['Signal_' num2str(sgn_i)]);
    else
        count = length(handles.iplot) + 1;
        handles.iplot(count) = htemp;
        handles.legend{count} = ['Signal_' num2str(sgn_i)];
        lbox_plot = cellstr(get(handles.listbox_plots,'String'));
        lbox_plot{count} = ['Signal_' num2str(sgn_i)];
        set(handles.listbox_plots,'String',lbox_plot);
    end
    
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
    guidata(hObject,handles)
 end