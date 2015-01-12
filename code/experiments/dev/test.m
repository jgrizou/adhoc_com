% init()
% run_all_exp(0)


allMethodCells = {};
allMethodCells{1} = {'adhoc_fullObs', 'A_FO', [0,51,102]};
allMethodCells{2} = {'adhoc_partialObs', 'A_PO', [0,102,204]};
allMethodCells{3} = {'adhoc_partialObsCom', 'A_POC', [51,153,255]};
allMethodCells{4} = {'adhoc_partialObsCom_findCardinalOnly', 'A_POC_FCAO', [102,56,0]};
allMethodCells{5} = {'adhoc_partialObsCom_findComOnly', 'A_POC_FCOO', [204,112,0]};
allMethodCells{6} = {'adhoc_partialObsCom_findLockingStateOnly', 'A_POC_FLSO', [255,163,51]};
allMethodCells{7} = {'adhoc_partialObsCom_useComOnly', 'A_POC_UCO', [80,41,22]};
allMethodCells{8} = {'adhoc_partialObsCom_useObsOnly', 'A_POC_UOO', [199,102,56]};
allMethodCells{9} = {'team_fullObs', 'T_FO', [28,74,35]};
allMethodCells{10} = {'team_partialObs', 'T_PO', [42,111,53]};
allMethodCells{11} = {'team_partialObsCom', 'T_POC', [70,185,88]};
allMethodCells{12} = {'team_partialObsCom_oneNoCom', 'T_POC_ONC', [144,213,155]};


fieldToCompare = 'time_to_capture';

%%

figPos3 = [2200,100,600,1000];

plotFolder = fullfile(pathstr, '../../../paper/plots');
plotFormats = {'png', 'eps'};



%%
figure('position', figPos3)
methodId = [9,1];
[bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare);
ylim([0,35])

plotFilenames = {'fullObs'};
save_all_images(plotFolder, plotFormats, plotFilenames)
close all

%%
figure('position', figPos3)
methodId = [9,10];
[bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare);
ylim([0,210])

plotFilenames = {'teamObsPartial'};
save_all_images(plotFolder, plotFormats, plotFilenames)
close all

%%
figure('position', figPos3)
methodId = [9,11,12];
[bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare);
ylim([0,35])

plotFilenames = {'teamObsPartialCom'};
save_all_images(plotFolder, plotFormats, plotFilenames)
close all

%%
figure('position', figPos3)
methodId = [11,3,12];
[bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare);
ylim([0,35])

plotFilenames = {'PartialCom'};
save_all_images(plotFolder, plotFormats, plotFilenames)
close all

%%
figure('position', figPos3)
methodId = [3,4,5,6];
[bh, ph] = plot_analysis_for_methods(allMethodCells, methodId, fieldToCompare);
ylim([0,35])

plotFilenames = {'AdhocMethods'};
save_all_images(plotFolder, plotFormats, plotFilenames)
close all




