clean

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
analysisFolder = fullfile(pathstr, 'analysis');

%% random

load(fullfile(analysisFolder, 'fixed_random.mat'))
noComLog = log;

load(fullfile(analysisFolder, 'aware_random.mat'))
withComLog = log;

[~,noComIdx,withComIdx] = intersect(noComLog.seed, withComLog.seed);

diffRandom = withComLog.iterations(withComIdx) - noComLog.iterations(noComIdx);

% plot(noComLog.iterations(noComIdx))
% hold on
% plot(withComLog.iterations(withComIdx), 'r')


%%
load(fullfile(analysisFolder, 'fixed_escape.mat'))
noComLog = log;

load(fullfile(analysisFolder, 'aware_escape.mat'))
withComLog = log;

[~,noComIdx,withComIdx] = intersect(noComLog.seed, withComLog.seed);

diffEscape =  withComLog.iterations(withComIdx) - noComLog.iterations(noComIdx);

% plot(noComLog.iterations(noComIdx))
% hold on
% plot(withComLog.iterations(withComIdx), 'r')

%%
maxExp = 1000;
iterations = nan(2, maxExp, 2);
iterations(1,1:length(diffRandom),1) = diffRandom;
iterations(1,1:length(diffRandom),2) = diffRandom;
iterations(2,1:length(diffEscape),1) = diffEscape;
iterations(2,1:length(diffEscape),2) = diffEscape;

methodNames = {'random', 'escape'};

%% 

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Courier')
DefaultAxesFontSize = 25;
set(0,'DefaultAxesFontSize', DefaultAxesFontSize)
set(0,'DefaultAxesFontWeight','bold')
set(0,'DefaultAxesLineWidth', 2.5)


figPositionSquare = [2386 46 1089 913];
figPositionFullWidth = [1667 541 1853 672];

OutlierMarker = 'x';
OutlierMarkerSize = 10;
OutlierMarkerFaceColor = 'k';
OutlierMarkerEdgeColor = 'k';
WidthE = 0.9;
WidthL = 0.5;
WidthS = 0.9;

labelNames = {'',''};

dimColor = [get_nice_color('b');get_nice_color('r')];
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

title('Same initial state for the diff')
xlabel('Options');
ylabel('Diff withCom-noCom iterations to capture');
[legh,objh,outh,outm] = legend(legendNames{:}, 'Location', 'BO');
% legend('boxoff')
set(legh,'linewidth',1);
% 
% hold on
% plot([0, 10], [0 0], 'k--')
xlim([0.7, 1.3])
ylim([-50 50])
set(gca, 'box', 'off')

%%

plotFolder = fullfile(pathstr, 'plots');
plotFormats = {'png', 'eps'};
plotFilenames = {'diffCom'};

save_all_images(plotFolder, plotFormats, plotFilenames)