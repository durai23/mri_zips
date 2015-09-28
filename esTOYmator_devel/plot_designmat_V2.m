function plot_designmat_V2(X,handles)
%Plot Design Matrix 'X'
%
% Syntax :
%   plot_designmat_V2(X,handles)
%
% Plot Design Matrix 'X'
%
% Input Parameters:
%     
%       handles          : Structure of handles. Same as GUIs.
%       X                : Design matrix
%
% Output Parameters:
                 

scrsz = get(0,'ScreenSize');                                           % Get screen size

% Retrieve data
 timings    = handles.timings;                                         % timings
 npts       = str2num(get(handles.edit_npoints, 'String'));            % npts
 num_runs   = str2num(get(handles.edit_num_runs, 'String'));           % No runs

% Adjust figure size for dual monitors
if scrsz(3) > 2*scrsz(4)
    rf = 4;
else
    rf = 2;
end;
scrsz(3) = scrsz(3)/rf;                                                    % Adjust width

figure('Name', 'Design Matrix','Position',scrsz);                          % Create fig
title('Design Matrix','fontsize',14,'FontWeight','bold')                   % Title of fig
hold on;

nstims = size(timings,1);                                                  % Get Number of stimulus
nbetas = size(X,2);                                                        % Get Number of Betas
npolys = nbetas - nstims;                                                  % Get Number of polynomials

% Step 1: Check settings for polynomials display
global glbopts
if glbopts.show_poly == 0
    Xplot =  X(:,end-nstims+1:end);
elseif glbopts.show_poly == 1
    Xplot = X;
end

% -------------------------- Plot Design Matrix --------------------------

% pcolor(Xplot);                                                           % Plot the design matrix
imagesc(Xplot);                                                            % Plot the design matrix
xlabel('Regressors','FontWeight','bold');                                  % X label
ylabel('TRs','FontWeight','bold');                                         % Y label
set(gca,'XLim',[0.5 size(Xplot,2) + 0.5]);                                 % Set the X limits
set(gca,'YLim',[1,npts*num_runs]);                                         % Set the Y limits
set(gca, 'Xtick',1:nstims)                                                 % Set the X ticks
grid on;                                                                   % Set grid 'on'
colorbar;                                                                  % Make colorbar appear
hold off                                                             
end

