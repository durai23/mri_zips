function X = createxmatrix_V2(handles)
% Create the design matrix using AFNI's 3ddeconvolve
%
% Syntax :
%   X = createxmatrix_V2(handles)
%
% This function takes the settings from the design and creates the design
% matrix for that experiment. For this, a chain of characters are sent to
% AFNI's 3dDeconvolve by using unix()
%
% Input Parameters:
%     
%       handles           :  Structure of handles. The same that GUIs use
%
% Output Parameters:
%       
%       X                 : Design Matrix             
%
% Related references:
%
%
% See also: readxmat



% Retrieving data
timings    = handles.timings;                                         % timings

if ~isfield(handles,'edit_iter')
    npts       = str2num(get(handles.edit_npoints, 'String'));            % npts
    num_runs   = str2num(get(handles.edit_num_runs, 'String'));           % No runs
    TR         = str2num(get(handles.edit_TR, 'String'));                 % TR
    hrf_gen    = handles.hrfs_gen_temp;                                   % HRFs
    
    list = get(handles.popupmenu_polort_gen,'String');                    % POLORT
    val  = get(handles.popupmenu_polort_gen,'Value');

else
    npts       = handles.opts.npts;               % npts
    num_runs   = handles.opts.num_runs;           % No runs
    TR         = handles.opts.TR    ;             % TR
    hrf_gen    = handles.hrfs_est;                % HRFs
    
    list = get(handles.popupmenu_polort_est,'String');                    % POLORT
    val  = get(handles.popupmenu_polort_est,'Value');
end
    

if val==1
    polort = -1;
else
    polort = list{val};
end

sp = blanks(1);
ntimings = size(timings,1);

if size(timings,1) ~= length(hrf_gen)
    msgbox('Conflict with number of Stimulus and HRFs','Error');
    return;
else
    
    % Create index for the beginnnig of each RUN
    indexr = zeros(1,num_runs);
    for i=2:num_runs
        indexr(i) = indexr(i-1) + npts;
    end
    
    to3ddeconv = ['3dDeconvolve -nodata' sp ...
        num2str(npts * num_runs) sp ...
        num2str(TR) sp ...
        '-concat ''1D: ' num2str(indexr) '''' sp ...
        '-polort' sp num2str(polort) sp ...
        '-num_stimts' sp num2str(ntimings) sp];
    
    % Add stim_times
    for i = 1: ntimings
        to3ddeconv = [to3ddeconv ...
            '-stim_times' sp num2str(i) sp timings(i,:) sp '''' hrf_gen{i} ''''  sp];
        %     '-stim_times_AM1' sp num2str(i) sp opts.timings(i,:) sp opts.hrf_gen sp];
    end
    
    % Add stim_labels
    for i = 1: ntimings
        to3ddeconv = [to3ddeconv ...
            '-stim_label' sp num2str(i) sp 'reg_' num2str(i) sp];
    end
    
    to3ddeconv = [to3ddeconv sp '-x1D' sp 'X.xmat.1D'];
    
    unix(to3ddeconv); % Send command to run in the terminal
    
    X = readxmat('X.xmat.1D');
    delete('X.xmat.1D');
    delete('X_XtXinv.xmat.1D');
end

end