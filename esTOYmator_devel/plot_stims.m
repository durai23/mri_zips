function plot_stims(handles)
%Plot stimulus (Exp Explorer)
%
% Syntax :
%   plot_stims(handles)
%
% Plot stimulus (Subplot Stimulus from timings files)
%
% Input Parameters:
%     
%       handles          : Structure of handles. The same that GUIs use
%
% Output Parameters:
%                   
%
% Related references: import_tfile_mod , subplot


plt_count = 0;                                           % Initialize Plot counter
scrsz = get(0,'ScreenSize');                             % Get screen size
f = figure('Name', 'Stimulus','Position',scrsz);         % Create fig
hold on;

index_selected = get(handles.listbox_reg,'Value');                    %Get variables selected from listbox_reg (list of regressors)

% 'All' option ------------------------------------------------------------
if sum(index_selected == size(handles.timings,1) + 1)
    index_selected = 1:size(handles.timings,1);
end
%--------------------------------------------------------------------------
    
reg_list = get(handles.listbox_reg,'String');
sel_reg = reg_list(index_selected);

nstims     =length(index_selected);                                   % Get Number of stimulus
cmap       = hsv(nstims);                                             % Vector of colors
num_runs   = str2num(get(handles.edit_num_runs, 'String'));           % No runs
npts       = str2num(get(handles.edit_npoints, 'String'));            % npts
TR         = str2num(get(handles.edit_TR, 'String'));                 % TR

try
 stim_dur = handles.stim_dur;
catch err
    msgbox('Select HRFs','Error');
    close(f);
    return;
end

sampling_rate = 10;                                                   % Use this fixed value to sample the number of points of the plots
%--------------------------------------------------------------------------
% Load Stimulus
  time = 0:TR/sampling_rate:TR*npts;

% Create a binary vector of stimulus to be plotted

for i = 1:nstims
     stimulus_i = import_tfile_mod(deblank(handles.timings(index_selected(i),:)), 1,num_runs); % Just import de onset
     base = zeros(num_runs,length(time));
     
    for j = 1: num_runs
        run_j = stimulus_i(j,:);
        
        % Find the closest value to the stimulus and assign '1'
        for t = 1:length(run_j)
            if run_j(t) ~=0
                [~,idx] = min(abs(time - run_j(t)));
                base(j,idx:idx+ceil(stim_dur(i)*sampling_rate/TR)) = 1;
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
    
%--------------------------------------------------------------------------   
% -------------------------- Plot Stimulus -------------------------------
plot_off = 0.05;                                                                   

% Figures of stimulus
c = 0;                                                                              % Counter
for i = 1 : nstims
    h0 = subplot(plt_count/2 + nstims + 1 ,2, [plt_count+i+c plt_count+i+1+c]);
    plot(allruns_time,allruns_stim(:,plt_count + i),'Color',cmap(i,:),'LineWidth',2);
    if i==1
        title(h0,'Stimulus','FontWeight','bold');                                   
    end
    ylabel(sel_reg(i,:),'FontWeight','bold','interpreter','none')                   % Lateral labels
    c = c+1;
    set(h0,'XLim',[0,npts*num_runs*TR]);                                            % Set the 'X' limits
    set(h0,'YLim',[0 1 + plot_off]);                                                % Set the 'Y' limits
    grid on;
end

% Plot Simulated Signal                                                                                             
h0 = subplot(plt_count/2 + nstims + 1 ,2, [2*(plt_count/2 + nstims+1)-1 2*(plt_count/2 + nstims + 1)]);   % Where to plot it
hold on;
for i = 1 : nstims
    plot(allruns_time,allruns_stim(:,plt_count + i),'-','Color',cmap(i,:),'LineWidth',2);                 % Subplot Stims
end
%title(h0,'All Stimulus','FontWeight','bold');                                                            % Set Title
ylabel('All','FontWeight','bold','interpreter','none')                                                    % LaTex Ylabel
set(h0,'XLim',[1,npts*num_runs*TR]);                                                                      % Set the X limits
set(h0,'YLim',[0 1 + plot_off]);                                                                          % Set the Y limits
xlabel('Time (s)','FontWeight','bold');                                                                   % Set the lower X label (TR)
grid on;
box on;

end
