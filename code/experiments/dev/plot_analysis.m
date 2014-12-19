clean

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
analysisFolder = fullfile(pathstr, 'analysis');

methodLogs = getfilenames(analysisFolder, 'refiles', '*.mat');
nMethod = length(methodLogs);

%%
maxExp = 10000;
iterations = nan(nMethod, maxExp, 2);
methodNames = cell(1, nMethod);

%%
for iMethod = 1:nMethod
    
    load(methodLogs{iMethod})        
    iterations(iMethod, 1:length(log.time_to_capture), 1) = log.time_to_capture;
    iterations(iMethod, 1:length(log.time_to_capture), 2) = log.time_to_capture;
    methodNames{iMethod} = strgsub(log.methodName, '_', ' ');    
end

%% 

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Courier')
DefaultAxesFontSize = 25;
set(0,'DefaultAxesFontSize', DefaultAxesFontSize)
set(0,'DefaultAxesFontWeight','bold')
set(0,'DefaultAxesLineWidth', 2.5)


figPositionSquare = [2600, 600, 800, 400];

OutlierMarker = 'x';
OutlierMarkerSize = 10;
OutlierMarkerFaceColor = 'k';
OutlierMarkerEdgeColor = 'k';
WidthE = 0.9;
WidthL = 0.5;
WidthS = 0.9;

labelNames = {'',''};

cstColor = 0.2;

dimColor = zeros(nMethod,3);
for i = 1:nMethod
    dimColor(i, :) = get_random_color();
end

% dimColor = [get_nice_color('b');get_nice_color('r');get_nice_color('g')];
% ;...
%     get_nice_color('g')-cstColor;get_nice_color('g')];
legendNames = methodNames;

%% time first
figure('Position', figPositionSquare)

aboxplot(iterations,'labels', labelNames, ...
    'Colormap', dimColor , ...
    'OutlierMarker', OutlierMarker, ...
    'OutlierMarkerSize', OutlierMarkerSize, ...
    'OutlierMarkerEdgeColor', OutlierMarkerEdgeColor, ...
    'OutlierMarkerFaceColor', OutlierMarkerFaceColor, ...
    'WidthE', WidthE, ...
    'WidthL', WidthL,...
    'WidthS', WidthS);

xlabel('Options');
ylabel('Nb iterations to capture');
[legh,objh,outh,outm] = legend(legendNames{:}, 'Location', 'BO');
% legend('boxoff')
set(legh,'linewidth',1);
% 
% hold on
% plot([0, 10], [251, 251], 'k--')
% xlim([0.7, 1.3])
% ylim([0 40])
% ylim([0 110])
set(gca, 'box', 'off')

%%

plotFolder = fullfile(pathstr, 'plots');
plotFormats = {'png', 'eps'};
plotFilenames = {'timeCapture'};

save_all_images(plotFolder, plotFormats, plotFilenames)
 