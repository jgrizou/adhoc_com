clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

foldersToAnalyse = {'expIJCAI_nonoise', 'expIJCAI'};

savePlots = 1;

for i = 1:length(foldersToAnalyse)
   
    disp(['Analysing ',  foldersToAnalyse{i}, ' ...'])
    folderName = fullfile(pathstr, '..', foldersToAnalyse{i});
    plot_all_for_folder(folderName, savePlots)
    
end