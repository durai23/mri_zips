function pushbutton_save_mainfunc(handles)
%Save structure with the experiment settings
%
% Syntax :
%   pushbutton_save_mainfunc(handles)
%
% Save structure with the experiment settings
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


if isfield(handles,'simresult')
    opts = handles.opts;
    save([opts.prefix '_config_file'], 'opts');       % Save configuration
end