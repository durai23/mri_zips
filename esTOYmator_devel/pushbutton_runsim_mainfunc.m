function  pushbutton_runsim_mainfunc(hObject,handles)
%Run a Simulation (Simulator)
%
% Syntax :
%   pushbutton_save_mainfunc(handles)
%
% Run the simulations using settings and options from the simulator.
%
% Input Parameters:
%     
%       handles        :  Handles of te GUI
%
% Output Parameters:
%
%
% Related references:
%
%
% See also: 


% Retrieve DATA
opts = handles.opts;
iter = str2num(get(handles.edit_iter, 'String'));
opts.hrf_est = handles.hrfs_est;
opts.snr     =  get(handles.edit_snr,'Value');

list = get(handles.popupmenu_polort_est,'String');
val  = get(handles.popupmenu_polort_est,'Value');
if val==1
    opts.polort_est = -1;
else
    opts.polort_est = list{val};
end

%Get variables selected from listbox_reg
index_selected = get(handles.listbox_hrf,'Value');                   
reg_list = get(handles.listbox_hrf,'String');
sel_reg = reg_list(index_selected);

isAll = strcmp('All',sel_reg);
isAll = isAll(1);

%Run 3dDeconv (nodata)
    X = createxmatrix_V2(handles);
    
    nbetas = size(X,2);
    real_betas = [ones(1,nbetas - handles.opts.num_stim) handles.opts.beta];
        
    % Create signal
    simresult.signal = sum(X.*repmat(real_betas,size(X,1),1),2);
    
    % Estimate
    
    wb = waitbar(0,'Please wait...');
    
    for i = 1:iter
        % computations take place here
        [simresult.betas_est(:,i),simresult.X_est(:,:,i),simresult.signal_wn(:,i)] = estimatex(simresult.signal ,opts);
        
        % waitbar computation take place here
        waitbar(i / iter);
    end
    close(wb);
    
    % In case of selection
    if length(index_selected) < handles.num_stim &&  ~isAll
        
        handles_temp = handles;
        handles_temp.timings = handles.timings(index_selected,:);
        handles_temp.hrfs_est = handles.hrfs_est(index_selected,:);
        
        opts_temp = opts;        
        opts_temp.timings  = opts.timings(index_selected,:);
        opts_temp.hrf_est  = opts.hrf_est(index_selected,:);

        
        %------------------------------------------------------------------%
        %------------------------------------------------------------------%
        X = createxmatrix_V2(handles_temp);
        
        nbetas = size(X,2);
        real_betas = [ones(1,nbetas - length(index_selected)) handles.opts.beta(index_selected)];
                
        % Estimation
        
        wb = waitbar(0,'Please wait...');
        
        for i = 1:iter
            % computations take place here
            [simresult.betas_est2(:,i),simresult.X_est2(:,:,i),simresult.signal_wn2(:,i)] = estimatex(simresult.signal ,opts_temp);
            
            % waitbar 
            waitbar(i / iter);
        end
        close(wb);
        %------------------------------------------------------------------%
        %------------------------------------------------------------------%
                    
    end
    
    % Update Reg ListBox
    if ~isAll
        regtemp = handles.regname(index_selected);
    else
        regtemp = handles.regname;
    end
%     regtemp{end + 1} = 'All';
    set(handles.listbox_reg,'String',regtemp);
    
    simresult.index_selected = index_selected;
    handles.simresult = simresult;
    handles.iter = iter;
    
    opts.simresult = simresult;
    opts.index_selected = index_selected;
    opts.isAll = isAll;
    opts.iter = iter;
    % Update opts
    handles.opts = opts;
    
    guidata(hObject,handles);