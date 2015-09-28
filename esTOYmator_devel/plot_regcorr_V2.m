function f = plot_regcorr_V2(X,handles)
%Plot the matrix of correlation between regressors and activate 'onclik'
%
% Syntax :
%   f = plot_regcorr_V2(X,handles)
%
% Plot the correlation matrix and activate the 'on click' functionality to
% display a figure with the linear relation between the Regressors
% corresponding to the row and column of the selected (by click) cell.
%
% Input Parameters:
%     
%       handles          : Structure of handles. The same that GUIs use
%       X                : Design matrix
%
% Output Parameters:]
% 
%       f                : Handles of the plot            
%
% See also: plot_fancycorr , regplot


% Retrieve data of the timings
 timings    = handles.timings;                                        % timings

% Poly stuff
nstims = size(timings,1);                                             % Get Number of stimulus
nbetas = size(X,2);                                                   % Get Number of Betas
npolys = nbetas - nstims;                                             % Get Number of polynomials

% Step 1: Check setting for polynomials display
global glbopts
if glbopts.show_poly == 0
    Xplot =  X(:,end-nstims+1:end); 
elseif glbopts.show_poly == 1
    Xplot = X;
end
%------------------------- Plot Correlation Matrix ------------------------

f =plot_fancycorr(Xplot);                                                  % Plot Correlation Matrix
set(f,'WindowButtonDownFcn',{@showreg_callback,Xplot});

    function showreg_callback(hObject,~,Xplot)
        % Plot the Linear Regression between the Regressors selected by
        % click in the Correlation Matrix
        
        [xt,yt] = ginput(1);                                               % Get click position
        x = round(xt);                                                     % Approximate  x coordinates to get nearest grid points
        y = round(yt);                                                     % Approximate  y coordinates to get nearest grid points
        
        % Check if the click was in the plotted area
        if x > 0 &&  x <= size(Xplot,2)+0.5 && y > 0 && y <= size(Xplot,2)+0.5 
            
            % now plot both the points in y and the curve fit in r
%             h = figure('Name', 'Linear Relation','Toolbar', 'none', 'WindowStyle', 'modal');   % Create fig
            hold on
%             plotregression(Xplot(:,x), Xplot(:,y));                                            % Plot Reg
            h =regplot(Xplot(:,x), Xplot(:,y),[x y],1);                                          % Plot Reg
%             set(h{1}, 'units', 'inches', 'position', [1 1 3 3])
%             xlabel(['Reg_' num2str(x)], 'FontWeight', 'bold');                                 % X label
%             ylabel(['Reg_' num2str(y)],'FontWeight', 'bold');                                  % Y label
            hold off
        else
            return;
        end
        set(h{1},'WindowButtonDownFcn',@closeonclick_callback);
        
        function closeonclick_callback(hObject,~)
            close(hObject);
        end
    end
end

