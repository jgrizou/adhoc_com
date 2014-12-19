function [bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare)

nMethod = length(methodId);

methodToCompare = cell(nMethod, 1);
methodShortNames = cell(nMethod, 1);
methodColors = cell(nMethod, 1);
for i = 1:nMethod    
    methodToCompare{i} = allMethodCells{methodId(i)}{1};
    methodShortNames{i} = allMethodCells{methodId(i)}{2};
    methodColors{i} = allMethodCells{methodId(i)}{3}/255;    
end


[bh, ph] = boxplot_analysis(fieldToCompare, methodToCompare, methodShortNames, methodColors);
