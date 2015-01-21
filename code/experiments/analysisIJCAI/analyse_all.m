clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

foldersToAnalyse = {'expIJCAI', 'expIJCAI_nonoise'};

for i = 1:length(foldersToAnalyse)
   
    disp(['Analysing ',  foldersToAnalyse{i}, ' ...'])
    folderName = fullfile(pathstr, '..', foldersToAnalyse{i});
    analyse_folder(folderName)
    
end