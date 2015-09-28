function plot_stimsconv_stims(X,handles)
%
% Syntax :
%   plot_stimsconv_stims(X,handles))
%
% Plot the stimulus convolved as well as the stimulus
%
% Input Parameters:
%     
%       handles          : Structure of handles. The same that GUIs use
%       X                : Design matrix 
%
% Output Parameters:
%                   
%
% Related references: import_tfile_mod , subplot


plt_count = 0;                                           % Initialize Plot counter
scrsz = get(0,'ScreenSize');                             % Get screen size
figure('Name', 'Stimulus Conv + Stims','Position',scrsz);             % Create fig
hold on;

index_selected = get(handles.listbox_reg,'Value');                    % Get variables selected from listbox_reg

% 'All' option ------------------------------------------------------------
if sum(index_selected == size(handles.timings,1) + 1)
    index_selected = 1:size(handles.timings,1);
end
%--------------------------------------------------------------------------

reg_list = get(handles.listbox_reg,'String');
sel_reg = reg_list(index_selected);

nstims     =length(index_selected);                                   % Get Number of stimulus
cmap       = hsv(nstims + 1);                                         % Vector of colors
num_runs   = str2num(get(handles.edit_num_runs, 'String'));           % No runs
npts       = str2num(get(handles.edit_npoints, 'String'));            % npts
TR         = str2num(get(handles.edit_TR, 'String'));                 % TR 
beta    = get(handles.uitable_beta,'Data');

try
 stim_dur = handles.stim_dur;
catch err
    msgbox('Select HRFs','Error');
    close(f);
    return;
end

sampling_rate = 10;                                                        % Use fixed value for now
%--------------------------------------------------------------------------
% Load Stimulus
  time = 0:TR/sampling_rate:TR*npts;

% Create a binary vector of stimulus onsets to be plotted  

for i = 1:nstims
    stimulus_i = import_tfile_mod(deblank(handles.timings(index_selected(i),:)), 1,num_runs);
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
    
Y=resample(X,sampling_rate,1);
Y(end+1:end+num_runs,:) = 0;
 
% -------------------------- Plot Stimulus --------------------------------
plot_off = 0.05;                                                                    

% Figures of stimulus conv
c = 0;                                                                              % Counter
for i = 1 : nstims
    h0 = subplot(plt_count/2 + nstims + 1 ,2, [plt_count+i+c plt_count+i+1+c]);
    plot(allruns_time,Y(:,plt_count + index_selected(i)),'Color',cmap(i,:),'LineWidth',2);
    hold on;
    plot(allruns_time,allruns_stim(:,plt_count + i),'--','Color',cmap(i,:),'LineWidth',1);
    if i==1
        title(h0,'Stimulus and Convolution','FontWeight','bold');               
    end
    ylabel(sel_reg(i,:),'FontWeight','bold','interpreter','none')                % Lateral labels
    c = c+1;
    set(h0,'XLim',[-0.05,npts*num_runs*TR]);                                     % Set the X limits
    set(h0,'YLim',[0 max(Y(:,plt_count + index_selected(i))) + plot_off]);       % Set the Y limits
    grid on;
end

% Get the SIGNAL
Ysignal = Y(:,index_selected);
betas = beta(index_selected);

% Create signal
signal = sum(Ysignal.*repmat(betas,size(Ysignal,1),1),2);

% Plot Simulated Signal
                                                                                             
h0 = subplot(plt_count/2 + nstims + 1 ,2, [2*(plt_count/2 + nstims+1)-1 2*(plt_count/2 + nstims + 1)]);   % Where to plot it
plot(allruns_time, signal + plot_off,'Color',cmap(end,:),'LineWidth',2.5);                                % Plot signal (Signal = sum(Stims))
hold on;
for i = 1 : nstims
    plot(allruns_time,Y(:,plt_count + index_selected(i)),'-','Color',cmap(i,:),'LineWidth',2);                       % Subplot Stims
    plot(allruns_time,allruns_stim(:,plt_count + i),'--','Color',cmap(i,:),'LineWidth',2);
end
%title(h0,'All Stimulus','FontWeight','bold');                                                                       % Set Title
ylabel('$\displaystyle\sum\limits_{i} \beta_i Stim_i$','interpreter','latex', 'FontSize',12,'FontWeight','bold');    % LaTex Ylabel
set(h0,'XLim',[1,npts*num_runs*TR]);                                                                                 % Set the X limits
set(h0,'YLim',[-0.05 max(signal + plot_off) + plot_off]);                                                            % Set the Y limits
xlabel('Time (s) ','FontWeight','bold');                                                                             % Set the lower X label (TR)
grid on;
box on;

end
