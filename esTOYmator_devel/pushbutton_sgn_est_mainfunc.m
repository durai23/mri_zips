function pushbutton_sgn_est_mainfunc(hObject,handles)
%Plot estimated signals with the selected option in the Signal_PLUS
% 
% Syntax :
%   pushbutton_sgn_est_mainfunc(hObject,handles)
%
% Button to plot estimated signal graph selected previuosly in Signal_PLUS.
% Depending on the selection each estimated regressor with its confidence interval 
% can be plotted.
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


cmap = jet(10);                                                            % Vector of colors

% Check if c_cmap is a field and initialize it
if ~isfield(handles,'c_cmap')
    handles.c_cmap = 1;
    guidata(hObject,handles);
end

% 1- Get variables selected from listbox_signals_est
index_selected = get(handles.listbox_signals_est,'Value');
reg_list = get(handles.listbox_signals_est,'String');
sel_sgn_est = reg_list{index_selected};

% 2- Get plot selected in popupmenu_est
list_plot   = get(handles.popupmenu_est,'String');
index_plot  = get(handles.popupmenu_est,'Value');
plot_type =list_plot{index_plot};

% 3- Check Confidence interval checkbox
ci_flag = get(handles.checkbox_ci,'Value');

% 4- Signal
sgn_est_i = get(handles.listbox_signals_est,'Value');
set(handles.listbox_signals,'Value',sgn_est_i);

signal_est = sum(handles.simresult.X_est(:,:,sgn_est_i).*repmat(handles.simresult.betas_est(:,sgn_est_i)',size(handles.simresult.X_est(:,:,sgn_est_i),1),1),2);

% 5-  Then plot each case
if get(handles.radiobutton_hold_sg,'value')
    hold on;
else
    try
        handles = rmfield(handles,'iplot');
        handles = rmfield(handles,'legend');
    catch err
    end;
end

if index_plot == 1
    msgbox('Select Plot','Error');
elseif index_plot == handles.opts.num_stim + 2;
    
    %**************************************************************************
    % PLot Signal
    
    htemp = plot(signal_est,'Color',cmap(handles.c_cmap,:),'LineWidth',2);
    
    % Create field and update handles
    if ~isfield(handles,'iplot')
        handles.iplot(1) = htemp;
        handles.legend{1} = ['Est_sgn_' num2str(index_selected)];
        set(handles.listbox_plots,'String',['Est_sgn_' num2str(index_selected)]);
    else
        count = length(handles.iplot) + 1;
        handles.iplot(count) = htemp;
        handles.legend{count} = ['Est_sgn_' num2str(index_selected)];
        lbox_plot = cellstr(get(handles.listbox_plots,'String'));
        lbox_plot{count} = ['Est_sgn_' num2str(index_selected)];
        set(handles.listbox_plots,'String',lbox_plot);
    end
    guidata(hObject,handles)
    
    plot_off = 0.0001;
%     legend(htemp,['Signals']);
    legend('boxoff');
    xlabel('TR');
    set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]);             % Set the X limits
    
    set(gca,'YLim',[min(handles.simresult.signal_wn(:))+ plot_off*min(handles.simresult.signal_wn(:)) max(handles.simresult.signal_wn(:)) + plot_off*max(handles.simresult.signal_wn(:))]); % Set the Y limits
    grid on;
    
else
    
    Reg = handles.simresult.X_est(:,index_plot-1,index_selected)*handles.simresult.betas_est(index_plot-1,index_selected);
    
    if ci_flag
        % Shaded Area
        plot_ci = @(x,lower,upper,color) set(fill([x,fliplr(x)],[upper,fliplr(lower)],color),'EdgeColor',color,'FaceAlpha', 0.6);  % Def funct
        
        % Get the Confidece Interval for the estimated regressor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Find a confidence interval for each component of x
        % Draper and Smith, equation 2.6.15, page 94
        ci = 0.2;
        alpha = 0.05;
        [n,ncolX] = size(handles.opts.X);
        
        % Use the rank-revealing QR to remove dependent columns of X.
        [Q,R,perm] = qr(handles.opts.X,0);
        if isempty(R)
            p = 0;
        elseif isvector(R)
            p = double(abs(R(1))>0);
        else
            p = sum(abs(diag(R)) > max(n,ncolX)*eps(R(1)));
        end
        if p < ncolX
            warning(message('stats:regress:RankDefDesignMat'));
            R = R(1:p,1:p);
            Q = Q(:,1:p);
            perm = perm(1:p);
        end
        
        RI = R\eye(p);
        nu = max(0,n-p);                                        % Residual degrees of freedom
        yhat = signal_est;                                      % Predicted responses at each data point.
        y = handles.simresult.signal_wn(:,index_selected);
        r = y-yhat;                                             % Residuals.
        normr = norm(r);
        if nu ~= 0
            rmse = normr/sqrt(nu);                              % Root mean square error.
            tval = tinv((1-alpha/2),nu);
        else
            rmse = NaN;
            tval = 0;
        end
        se = zeros(ncolX,1);
        se(perm,:) = rmse*sqrt(sum(abs(RI).^2,2));
        ci = tval*se;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        t = 1:handles.opts.npts*handles.opts.num_runs;
        hold on;
        plot_ci(t,(Reg - ci(index_plot-1))',(Reg + ci(index_plot-1))',[0.9 0.9 0.9])
        set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]);             % Set the X limits
    end
    
    htemp = plot(Reg ,'Color',cmap(handles.c_cmap,:),'LineWidth',2);
    
    % Create field and update handles
    if ~isfield(handles,'iplot')
        handles.iplot(1) = htemp;
        handles.legend{1} = ['Sgn_' num2str(index_selected) '_' plot_type];
        set(handles.listbox_plots,'String',['Sgn_' num2str(index_selected) '_' plot_type]);
    else
        count = length(handles.iplot) + 1;
        handles.iplot(count) = htemp;
        handles.legend{count} = ['Sgn_' num2str(index_selected) '_' plot_type];
        lbox_plot = cellstr(get(handles.listbox_plots,'String'));
        lbox_plot{count} = ['Sgn_' num2str(index_selected) '_' plot_type];
        set(handles.listbox_plots,'String',lbox_plot);

    end
    guidata(hObject,handles)
    
    
    plot_off = 0.0001;
%     legend(htemp,['Signals']); FIX THIS
    legend('boxoff');
    xlabel('TR');
    set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]);           % Set the X limits
    
    set(gca,'YLim',[min(handles.simresult.signal_wn(:))+ plot_off*min(handles.simresult.signal_wn(:)) max(handles.simresult.signal_wn(:)) + plot_off*max(handles.simresult.signal_wn(:))]); % Set the Y limits
    grid on;
    
    if ci_flag
        hold off;
    end
end

handles.c_cmap = handles.c_cmap + 1;
guidata(hObject,handles);

if get(handles.radiobutton_hold_sg,'value')
    hold off;
end