function  h = plot_fancycorr(mat)
%Plot the matrix of correlation between regressors
%
% Syntax :
%   h = plot_fancycorr(mat)
%
% Plot the correlation matrix 'mat' and display the values of the
% correlation in each cell.
%
% Input Parameters:
%     
%       mat                : Correlation matrix of regressors
%
% Output Parameters:
%       h                  : Handles of the plot            
%
% See also: plot_fancycorr , regplot


scrsz = get(0,'ScreenSize');                       % Get screen size

% Adjust figure size for dual monitors
if scrsz(3) > 2*scrsz(4)
    rf = 4;
else
    rf = 2;
end;
scrsz(3) = scrsz(3)/rf;
scrsz(1) = scrsz(3);

h = figure('Name', 'Correlation Marix','Position',scrsz);                                                % Create fig
title('Correlation Matrix','fontsize',14,'fontweight','b','FontWeight','bold');                          % Title of fig
hold on

%--------------------------------------------------------------------------

% [pvalmat,corrmat]=corrcoef(mat);                   % get corr matrix (BUG FIXED 2-19-2014)
[corrmat,pvalmat]=corrcoef(mat);                   % get corr matrix

pvalmat_up = triu(pvalmat,1);                      % Get pvalues for multiple correlation

vmax = abs(max(max(corrmat)))*1.15;                % Max of corr
vmin = -vmax;                                      % Min is -1*Max

% imagesc(corrmat,[vmin vmax]);
imagesc(abs(corrmat),[0 1]);
% pcolor(corrmat);
hold off
% colormap(flipud(jet));
colormap(jet);

% Create Labels for Reg in grid
for i= 1: length(corrmat)
    reg_text{i} = ['Reg_' num2str(i)];            % Reg_1 ... Reg_N
end

% Create pvalues strings from the matrix values
for i = 1 : length(pvalmat_up(:))
    if pvalmat_up(i) ~= 0
        %         textStrings(i,:) = num2str(abs(pvalmat_up(i)),'%0.3f');
        textStrings(i,:) = num2str(abs(corrmat(i)),'%0.3f');               % Display Corr values instead pvals (4/3/2014)
    else
        textStrings(i,:) = blanks(5);
    end
end

textStrings = strtrim(cellstr(textStrings));                               % Remove any space padding
textStrings(1:length(corrmat)+1:end) = reg_text;                           % Create strings from the matrix values
[x,y] = meshgrid(1:length(corrmat));                                       % Create x and y coordinates for the strings

hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','FontWeight','bold');      % Plot the strings
xlabel('Regressors','FontWeight','bold');                                  % X label
ylabel('Regressors','FontWeight','bold');                                  % Y label

set(gca,'XLim',[0.5 length(corrmat) + 0.5]);                               % Setting the X limits
set(gca,'YLim',[0.5 length(corrmat) + 0.5]);                               % Setting the Y limits


set(gca, 'Xtick',1:length(corrmat))                                        % Setting the X ticks
set(gca, 'Ytick',1:length(corrmat))                                        % Setting the X ticks
colorbar;
grid on;
box off;
% hold off;
