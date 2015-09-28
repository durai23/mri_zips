function save_confile(handles)
% Generate and save an experiment configuration file
%
% Syntax :
%   customtimes_main_V2(handles)
%
% Generate and save structure with the options for the experiment. 
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
% See also: createxmatrix_V2



% global timings;
% global optstemp;
err_flag = 0;

% POLORT  %--- Modified to allow selection ---%

list = get(handles.popupmenu_polort_gen,'String');
val  = get(handles.popupmenu_polort_gen,'Value');
if val==1
    opts.polort_gen = -1;
else
    opts.polort_gen = list{val};
end
%--------------------------------------------------------------------------
opts.project_path = pwd;
opts.handles = handles;
opts.prefix  = get(handles.edit_prefix, 'String');                         % Prefix of sim
opts.snr        = str2num(get(handles.edit_snr, 'String'));                % SNR
opts.TR         = str2num(get(handles.edit_TR, 'String'));                 % TR
opts.npts       = str2num(get(handles.edit_npoints, 'String'));            % npts
opts.num_stim   = str2num(get(handles.edit_num_stim, 'String'));           % No stims
opts.num_runs   = str2num(get(handles.edit_num_runs, 'String'));           % No runs
opts.run_time   = opts.TR * opts.npts ;                                    % Run time
opts.regnames   = handles.regname;                                         % Regressors Name
opts.stim_dur    = handles.stim_dur;

% HRF  %--- Modified to allow multiples HRF ---%

list = get(handles.popupmenu_hrf_sim,'String');
val  = get(handles.popupmenu_hrf_sim,'Value');

opts.hrf_gen_list  = list;
opts.hrf_gen_value = val;

if val ~= 1
%     opts.hrf_gen = optstemp.hrfs_gen_temp; M
    opts.hrf_gen = opts.handles.hrfs_gen_temp;
    
else
    err_flag = msgbox('Enter a valid HRFs','Warning !!!','Warn');
end

%---------------------------------------------------------------
% Check entries
if  isempty(opts.snr) ||...
        isempty(opts.TR) || ...
        isempty(opts.num_runs) ||...
        isempty(opts.run_time) ||...
        isempty(opts.prefix) ||...
        isempty(opts.polort_gen)||...
        isempty(handles.timings)
    err_flag = msgbox('Check your entries','Warning !!!!','Warn');
else
    err_flag = err_flag;
end
%-
% ----------------- BETAS Stuff -----------------------
% Betas (Just the betas for the stimulus) This lines was changes from V1 to V0.1
% opts.beta    = str2num(get(handles.edit_beta, 'String')); % If Use polort A   size(beta) = floor(npts*TR/150)+ 1 +size(timings) to be fixed
opts.beta    = get(handles.uitable_beta,'Data'); 

% if length(opts.beta) ~= opts.num_stim
%     err_flag = msgbox(['Must enter ' num2str(opts.num_stim) ' beta values' ],'Hi','Warning');
% else
%     err_flag = 0;
% end

% -------------------------------------------------------------------------
 % Get X to save it.
 opts.X = createxmatrix_V2(handles);
% -------------------------------------------------------------------------

if err_flag == 0
    opts.timings = handles.timings;                           % Create timing files
    save([opts.prefix '_config_file'], 'opts');       % Saving configuration
end
% clear global;                        % ------------------------------------
clc;
display('------------------- Timing Files -------------------');
display(handles.timings);
display('----------------------------------------------------');

end

