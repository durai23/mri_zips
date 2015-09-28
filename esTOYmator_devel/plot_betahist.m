function plot_betahist(betas_est,realB,regname)
%Plot the histograms of the estimated betas
% 
% Syntax :
%   plot_betahist(betas_est,realB,regname)
%
% Plot the histograms of the estimated betas
%
% Input Parameters:
%     
%       betas_est        :  matrix of the estimated betas for each
%                           regressor on each instantiation
%       realB            :  Betas values used in the forward model (generation). 
%                           The same for each instantiation        
%       regname          :  Cell with the name of the regressors
%
% Output Parameters:
%
%
% Related references:
%
%
% See also: SUBPLOT


% Figure stuff
scrsz = get(0,'ScreenSize');
figure('Name', 'Estimated Betas','Position',scrsz);
hold on;

% npol =  floor(opts.npts*opts.TR/150)+ 2; % V1 to V1.1
% npol =  length(opts.realB) - opts.num_stim ;

for i = 1 : length(realB)
    mn = mean(betas_est(i,:));                                             % Calculate mean of betas
    stdv = std(betas_est(i,:));                                            % Calculate standard deviation
    
    % Subplot stuff for the case of having only one beta value
    if length(realB) > 1
        h0 = subplot(ceil(length(realB)/2),2,i);
    else
        h0 = subplot(1,1,i);
        set(h0,'box', 'on');
    end
    
    h_hist = histfit(betas_est(i,:),30);                                   % Create thistogram
    h1 = get(gca,'Children');
    set(h1(2),'FaceColor',[.8 .8 1]);                                      % Color
    set(h0,'XLim',[min(betas_est(i,:)) max(betas_est(i,:))]);              % X limit
    
    hold on;
    y_max = max(max(get(h_hist(2),'Ydata')));
    h2 = plot(mn,y_max,'--rs','MarkerSize',10, 'Color', [1 0 0], 'MarkerFaceColor',[1 0 0]);        % Plot Beta's mean
    h3 = plot(realB(i),y_max,'--rs','MarkerSize',10, 'Color', [0 1 0], 'MarkerFaceColor',[0 1 0]);  % Plot real beta
    h4 = legend([h2,h3],'Est. Beta Mean','Real Beta');                                              % Legend
    set(h4,'box', 'off');
    
    hold off;
    
    title(h0,['Beta_{' num2str(i) '}' ' = ' num2str(realB(i)) '    Beta_{' num2str(i) '}' '''' '  ( Mean = ' num2str(mn) '  Std = ' num2str(stdv) ')'],'LineWidth',2);
    ylabel(['f(' regname{i} ')'],'LineWidth',3,'Interpreter','None');
    xlabel('Beta Value','LineWidth',3,'Interpreter','None');
end
