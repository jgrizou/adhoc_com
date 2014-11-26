clean

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
resultFolder = fullfile(pathstr, 'results');

analysisFolder = fullfile(pathstr, 'analysis');
ensure_new_folder(analysisFolder)

rF = getfilenames(resultFolder);

for irF = 1:length(rF)
    
    disp('###')
    add_counter(irF, length(rF))
    disp(' ')
    
    log = Logger();
    [~,methodName,~] = fileparts(rF{irF});
    log.logit(methodName)
    
    subF = getfilenames(rF{irF}, 'refiles', '*.mat');
    for isubF = 1:length(subF)
        add_counter(isubF, length(subF))
        
        load(subF{isubF})
        
        runTime = sum(rec.loopTime); log.logit(runTime)
        
        time_to_capture = length(rec.loopTime); log.logit(time_to_capture)
                
        log.log_from_logger(rec, 'seed')        
        
        remove_counter(isubF, length(subF))
    end
    
    [~, fname] = fileparts(rF{irF});
    saveFile = fullfile(analysisFolder, fname);
    log.save(saveFile)
    
    disp(' ')
end