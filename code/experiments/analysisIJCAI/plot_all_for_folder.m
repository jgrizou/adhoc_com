function plot_all_for_folder(folderName, savePlots)

    %%
    allMethodCells = {};
    allMethodCells{1} = {'adhoc_fullObs', 'A-FO', [0,51,102]};
    allMethodCells{2} = {'adhoc_partialObs', 'A-PO', [0,102,204]};
    allMethodCells{3} = {'adhoc_partialObsCom', 'A-POC', [51,153,255]};
    allMethodCells{4} = {'adhoc_partialObsCom_findCardinalOnly', 'A-POC-FCAO', [102,56,0]};
    allMethodCells{5} = {'adhoc_partialObsCom_findComOnly', 'A-POC-FCOO', [204,112,0]};
    allMethodCells{6} = {'adhoc_partialObsCom_findLockingStateOnly', 'A-POC-FLSO', [255,163,51]};
    allMethodCells{7} = {'team_fullObs', 'T-FO', [28,74,35]};
    allMethodCells{8} = {'team_partialObs', 'T-PO', [42,111,53]};
    allMethodCells{9} = {'team_partialObsCom', 'T-POC', [70,185,88]};
    allMethodCells{10} = {'team_partialObsCom_oneNoCom', 'T-POC-ONC', [144,213,155]};
    allMethodCells{11} = {'random_fullObs', 'R-FO', [28,74,35]};
    allMethodCells{12} = {'random_partialObs', 'R-PO', [42,111,53]};
    allMethodCells{13} = {'random_partialObsCom', 'R-POC', [70,185,88]};
    
    %%
    analysisFolder = fullfile(folderName, 'analysis');

    % Change default axes fonts.
    set(0,'DefaultAxesFontName', 'Courier')
    DefaultAxesFontSize = 25;
    set(0,'DefaultAxesFontSize', DefaultAxesFontSize)
    set(0,'DefaultAxesFontWeight','bold')
    set(0,'DefaultAxesLineWidth', 2.5)

    figPos = [1800,50,1300,1000];
    
    yLimits = [-0.2,15];

    markerStep = 40;
    markersize = 500;
    linewidth = 3;

    plotFolder = fullfile(folderName, 'plots');
    plotFormats = {'png', 'eps'};

    %%
    figure('position', figPos)
    methodId = [7,8,9];
    markerType = {'*', 's', 'o'};
    legendProp = {'Location', 'NW'};

    [Hs, Ss] = plot_nCaptured_for_methods(analysisFolder, allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp);
    plot([0,200], [0,0], 'k--')
    ylim(yLimits)

    plotFilenames = {'teamComparaison'};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end

    %%
    figure('position', figPos)
    methodId = [1,7,11];
    markerType = {'*', 's', 'o'};
    legendProp = {'Location', 'NW'};

    [Hs, Ss] = plot_nCaptured_for_methods(analysisFolder, allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp);
    plot([0,200], [0,0], 'k--')
    ylim(yLimits)

    plotFilenames = {'fullObs'};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end

    %%
    figure('position', figPos)
    methodId = [3,9,10,13];
    markerType = {'*', 'o', 's', '+'};
    legendProp = {'Location', 'NW'};

    [Hs, Ss] = plot_nCaptured_for_methods(analysisFolder, allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp);
    plot([0,200], [0,0], 'k--')
    ylim(yLimits)

    plotFilenames = {'partialObsCom'};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end

    %%
    figure('position', figPos)
    methodId = [3,4,5,6,9,10,13];
    markerType = {'*', '^', 'v', '>', 'o', 's', '+'};
    legendProp = {'Location', 'NW'};

    [Hs, Ss] = plot_nCaptured_for_methods(analysisFolder, allMethodCells, methodId, markerStep, markersize, linewidth, markerType, legendProp);
    plot([0,200], [0,0], 'k--')
    ylim(yLimits)

    plotFilenames = {'partialObsCom_subset'};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end

    %%
    figure('position', figPos)
    hold on

    methodId = [1, 3,4,5,6];
    markerType = {'s', '*', '^', 'v', '>'};
    legendProp = {'Location', 'NE'};

    markerStep = 10;
    markerStart = round(linspace(1,markerStep,length(methodId)+1));

    Hs = cell(length(methodId), 1);
    Ss = cell(length(methodId), 1);
    legendRef = zeros(length(methodId),1);
    legendName = cell(length(methodId),1);
    for i = 1:length(methodId)
        load(fullfile(analysisFolder, [allMethodCells{methodId(i)}{1}, '.mat']));
        
        x = 1:size(log.loopTime,1);
        y = log10(log.loopTime');
        
        mean_y = mean(y,1); 
        std_error =  std(y,[],1)/sqrt(size(y,1));
        
        x_marker = [x(markerStart(i):markerStep:end)];
        mean_y_marker = [mean_y(markerStart(i):markerStep:end)];
        
        color = allMethodCells{methodId(i)}{3}/255;
        lineProps = {'color', color, 'LineWidth', linewidth};
        transparence = 1;
        
        Hs{i} = shadedErrorBar(x, mean_y, std_error, lineProps, transparence);
        Ss{i} = scatter(x_marker, mean_y_marker, markersize, color, markerType{i}, 'LineWidth', linewidth);

        legendRef(i) = Ss{i};
        legendName{i} = allMethodCells{methodId(i)}{2};

    end

    h = legend(legendRef, legendName{:}, legendProp{:});
    M = findobj(h, 'type', 'patch');
    set(M, 'MarkerSize', sqrt(markersize), 'LineWidth', linewidth);
    xlim([0,50])
    ylim([0,5.5])

    plotFilenames = {'computationalTime'};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end