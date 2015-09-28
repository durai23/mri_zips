function h = plot_signals_stims(handles)
%Plot the Stimulus in Signal_PLUS
% 
% Syntax :
%   h = plot_signals_stims(handles)
%
%   Plot the Stimulus in the Signal_PLUS
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
% See also: IMPORT_TFILE_MOD

plt_count = 0;                                                        % Initialize Plot counter
% hold on;

index_selected = get(handles.listbox_ref,'Value');                    % Get variables selected from listbox_reg
reg_list = get(handles.listbox_ref,'String');
sel_ref = reg_list(index_selected);

nstims     =length(index_selected);                                   % Get Number of stimulus
cmap       = hsv(15);                                                 % Vector of colors

num_runs   = handles.opts.num_runs;           % No runs
npts       = handles.opts.npts;               % npts
TR         = handles.opts.TR;                 % TR
beta       = handles.opts.beta;               % beta
stim_dur   = handles.opts.stim_dur;

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------------------------------------------------

sampling_rate = 1;                                                         % To sample the points in the vector and make it plottable :)
%--------------------------------------------------------------------------
% Load Stimulus
%   time = 0:TR/sampling_rate:TR*npts;
time = 0:TR:TR*npts;                                                                                % Create the vector of time

% Create a binary vector of stimulus to be plotted  

for i = 1:nstims
    stimulus_i = import_tfile_mod(deblank(handles.opts.timings(index_selected(i),:)), 1,num_runs);
    base = zeros(num_runs,length(time));
    
    for j = 1: num_runs
        run_j = stimulus_i(j,:);
        
        % Find the closest value to the stimulus and assign '1'
        for t = 1:length(run_j)
            if run_j(t) ~=0
                [~,idx] = min(abs(time - run_j(t)));
                base(j,idx:idx+ceil(stim_dur(i)/TR)) = 1;
            end
        end
    end
    
    if num_runs > 1
        baseT = base';
        allruns_stim(i,:) = baseT(:);
    else
        allruns_stim(i,:) = base;
    end
end
allruns_stim = allruns_stim';
allruns_time = 0:TR/sampling_rate:(TR*npts*num_runs + (num_runs-1)*TR/sampling_rate) ;


% -------------------------- Plot Stimulus --------------------------------
plot_off = 0.05;                                                             

% Plot stimulus

h = plot(allruns_stim(:,1),'-','Color',cmap(handles.c_cmap,:),'LineWidth',2);
set(gca,'XLim',[1,handles.opts.npts*handles.opts.num_runs]);                  % X limit
grid on;
% hold off;
end
