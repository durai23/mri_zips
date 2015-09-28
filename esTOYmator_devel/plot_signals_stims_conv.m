function  h = plot_signals_stims_conv(X,handles)
% Plot stimulus convolved (Subplot Stimulus from timings files)
% 
% Syntax :
%   h = plot_signals_stims_conv(X,handles)
%
%   Plot the Stimulus Convolved in the Signal_PLUS and Betas_play
%
%
% Input Parameters:
%     
%       handles           : Structure of handles. The same that GUIs use
%
% Output Parameters:
%       
%       h                 : Handles of the plot
%
% Related references:
%
%
% See also:


plt_count = 0;                                                        % Initialize Plot counter
% hold on;

index_selected = get(handles.listbox_ref,'Value');                    % Get variables selected from listbox_reg
reg_list = get(handles.listbox_ref,'String');
sel_ref = reg_list(index_selected);

nstims     =length(index_selected);                                   % Get Number of stimulus
cmap       = hsv(10);                                                 % Vector of colors

num_runs   = handles.opts.num_runs;           % No runs
npts       = handles.opts.npts;               % npts
TR         = handles.opts.TR;                 % TR
beta       = handles.opts.beta;               % beta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Possible feature to display polynomials alongside the other regressors 

% % Step 1: Check setting for polynomials display
% global glbopts
% if glbopts.show_poly == 0
%     nplots = nstims + 1;             % Nplots without polynomials
%     cmap = hsv(nplots);              % Vector of colors
% %     cmap = jet(nplots);              % Vector of colors
%     
% elseif glbopts.show_poly == 1
%     nplots = npolys + nstims + 1;    % Nplots with polynomials
%     cmap = hsv(nplots);              % Vector of colors
% %     cmap = jet(nplots);              % Vector of colors
%     
%     % Step 2: Check if X have polynomials embeded and plot them
%     if npolys ~= 0
%         % Plot polys
%         for i = 1 : npolys
%             h0 = subplot(npolys/2 + nstims + 1 ,2,i);
%             plot(X(:,i));
%             ylabel(['P_' num2str(i-1)],'LineWidth',2);
%             plt_count = plt_count + 1;
%         end
%     end
% end

% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figures of stimulus conv
    h = plot(X(:,plt_count + index_selected(1))*beta(index_selected),'Color',cmap(handles.c_cmap,:),'LineWidth',2);
    set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]); 
grid on;
% hold off;
end


