function [bh, ph] = boxplot_analysis(fieldToCompare, methodToCompare, methodShortNames, methodColors)

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
analysisFolder = fullfile(pathstr, 'analysis');

methodLogs = getfilenames(analysisFolder, 'refiles', '*.mat');
nMethod = length(methodLogs);

methodNames = cell(nMethod, 1);
for i = 1:nMethod
    [~, methodNames{i}, ~] = fileparts(methodLogs{i});
end


dataCells = {};
for iMethod = 1:length(methodToCompare)
    
    id = find(strcmp(methodToCompare{iMethod}, methodNames));
    
    load(methodLogs{id})
    
    dataCells{iMethod}.values = log.(fieldToCompare);
    dataCells{iMethod}.name = methodShortNames{iMethod};    
    dataCells{iMethod}.color = methodColors{iMethod};
    dataCells{iMethod}.legendName = strgsub(log.methodName, '_', ' ');
    
end

boxplotargs = {'widths', 0.8};
outliersargs =  {'Marker', 'x', 'MarkerEdgeColor', [0.4,0.4,0.4], 'MarkerSize', 5};
medianargs = {'Color', [0,0,0], 'LineWidth', 2};
patchargs = {};
legendargs = {'Location', 'NO'};

[bh, ph] = cboxplot(dataCells, boxplotargs, outliersargs, medianargs, patchargs, legendargs);
set(findobj(gca, 'Type', 'text'), 'FontSize', 15, 'VerticalAlignment', 'Top')

xlim([0.5, length(methodToCompare)+0.5])




% ylim([0, 30])
% legend('off')