function [Hs, Ss] = plot_nCaptured_for_methods(analysisFolder, allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp)

methodLogs = getfilenames(analysisFolder, 'refiles', '*.mat');
nMethod = length(methodLogs);

methodNames = cell(nMethod, 1);
for i = 1:nMethod
    [~, methodNames{i}, ~] = fileparts(methodLogs{i});
end

%%
nMethod = length(methodId);

methodToCompare = cell(nMethod, 1);
methodShortNames = cell(nMethod, 1);
methodColors = cell(nMethod, 1);
for i = 1:nMethod    
    methodToCompare{i} = allMethodCells{methodId(i)}{1};
    methodShortNames{i} = allMethodCells{methodId(i)}{2};
    methodColors{i} = allMethodCells{methodId(i)}{3}/255;
end

%%
dataCells = cell(length(methodToCompare), 1);
for iMethod = 1:length(methodToCompare)
    
    id = find(strcmp(methodToCompare{iMethod}, methodNames));
    
    load(methodLogs{id})
    
    y = log.nPreyLocked';
   
    dataCells{iMethod}.meanCapture = mean(y,1);
    dataCells{iMethod}.stdErrorCapture = std(y,[],1)/sqrt(size(y,1));
    dataCells{iMethod}.name = methodShortNames{iMethod};    
    dataCells{iMethod}.color = methodColors{iMethod};    
end


%%

markerStart = round(linspace(1,markerStep,length(dataCells)+1));

Hs = cell(length(dataCells), 1);
Ss = cell(length(dataCells), 1);

hold on
legendRef = zeros(length(dataCells), 1);
legendName = cell(length(dataCells), 1);
for i = 1:length(dataCells)
    
    x = 1:length(dataCells{i}.meanCapture);
    mean_y = dataCells{i}.meanCapture;
    std_error = dataCells{i}.stdErrorCapture;
    
    x_marker = [x(markerStart(i):markerStep:end)];
    mean_y_marker = [mean_y(markerStart(i):markerStep:end)];

%     x_marker = [x(1), x(markerStart(i):markerStep:end), x(end)];
%     mean_y_marker = [mean_y(1), mean_y(markerStart(i):markerStep:end), mean_y(end)];

%     lineProps = {'color', dataCells{i}.color, ...
%         'Marker', markerType{i}, ...
%         'MarkerEdgeColor', dataCells{i}.color, ...
%         'MarkerFaceColor', dataCells{i}.color, ...
%         'MarkerSize', markersize, ...
%         'LineWidth', linewidth};
    lineProps = {'color', dataCells{i}.color, 'LineWidth', linewidth};
    transparence = 1;
    
    Hs{i} = shadedErrorBar(x, mean_y, std_error, lineProps, transparence);
    Ss{i} = scatter(x_marker, mean_y_marker, markersize, dataCells{i}.color, markerType{i}, 'LineWidth', linewidth);
    
%     legendRef(i) = Hs{i}.mainLine;
    legendRef(i) = Ss{i};
    legendName{i} = dataCells{i}.name;
    
end

h = legend(legendRef, legendName{:}, legendProp{:});
M = findobj(h, 'type', 'patch');
set(M, 'MarkerSize', sqrt(markersize), 'LineWidth', linewidth);


