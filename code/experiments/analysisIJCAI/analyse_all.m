clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

foldersToAnalyse = {'expIJCAI_nonoise', 'expIJCAI'};

for i = 1:length(foldersToAnalyse)
   
    disp(['Analysing ',  foldersToAnalyse{i}, ' ...'])
    folderName = fullfile(pathstr, '..', foldersToAnalyse{i});
    analyse_folder(folderName)
    
end