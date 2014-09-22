clean

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
resultFolder = fullfile(pathstr, 'results');

analysisFolder = fullfile(pathstr, 'analysis');
if ~exist(analysisFolder, 'dir')
   mkdir(analysisFolder) 
end

rF = getfilenames(resultFolder);

for irF = 1:length(rF)
    
    disp('###')
    add_counter(irF, length(rF))
    disp(' ')
    
    subF = getfilenames(rF{irF}, 'refiles', '*.mat'); 
    
    log = Logger();
    for isubF = 1:length(subF)
        add_counter(isubF, length(subF))
        load(subF{isubF})
        log.log_from_logger(rec, {'seed','iterations'})
        remove_counter(isubF, length(subF))
    end
    log.log_from_logger(rec, 'expFolderName')
    
    
    [~, fname] = fileparts(rF{irF});
    saveFile = fullfile(analysisFolder, fname);  
    log.save(saveFile)
    
    disp(' ')    
end