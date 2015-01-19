function Hs = plot_nCaptured_for_methods(allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp)

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
analysisFolder = fullfile(pathstr, 'analysis');

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
   
    dataCells{iMethod}.meanCapture = mean(y);
    dataCells{iMethod}.stdErrorCapture = std(y)/sqrt(size(y,1));
    dataCells{iMethod}.name = methodShortNames{iMethod};    
    dataCells{iMethod}.color = methodColors{iMethod};    
end


%%

markerStart = round(linspace(1,markerStep,length(dataCells)+1));

Hs = cell(length(dataCells), 1);

hold on
legendRef = zeros(length(dataCells), 1);
legendName = cell(length(dataCells), 1);
for i = 1:length(dataCells)
    
    x = 1:length(dataCells{i}.meanCapture);
    mean_y = dataCells{i}.meanCapture;
    std_error = dataCells{i}.stdErrorCapture;
    
    x = [x(1), x(markerStart(i):markerStep:end), x(end)];
    mean_y = [mean_y(1), mean_y(markerStart(i):markerStep:end), mean_y(end)];
    std_error = [std_error(1), std_error(markerStart(i):markerStep:end), std_error(end)];
    
    lineProps = {'color', dataCells{i}.color, ...
        'Marker', markerType{i}, ...
        'MarkerEdgeColor', dataCells{i}.color, ...
        'MarkerFaceColor', dataCells{i}.color, ...
        'MarkerSize', markersize, ...
        'LineWidth', linewidth};
    transparence = 1;
    
    Hs{i} = shadedErrorBar(x, mean_y, std_error, lineProps, transparence);
    
    legendRef(i) = Hs{i}.mainLine;
    legendName{i} = dataCells{i}.name;
    
end

legend(legendRef, legendName{:}, legendProp{:})



