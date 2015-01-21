function analyse_folder(folderName)

resultFolder = fullfile(folderName,  'results');

analysisFolder = fullfile(folderName, 'analysis');
ensure_new_folder(analysisFolder)

rF = getfilenames(resultFolder);

for irF = 1:length(rF)
    
    disp('###')
    add_counter(irF, length(rF))
    
    log = Logger();
    [~,methodName,~] = fileparts(rF{irF});
    log.logit(methodName)
    
    subF = getfilenames(rF{irF}, 'refiles', '*.mat');
    disp(['-> ', num2str(length(subF))])
    for isubF = 1:length(subF)
        add_counter(isubF, length(subF))
        
        try
            load(subF{isubF})
        catch err
            disp(['Could not load: ', subF{isubF}])
            disp('Deleting it...')
            delete(subF{isubF})
            continue
        end
                        
        runTime = sum(rec.loopTime); log.logit(runTime)
        
        log.log_from_logger(rec, 'loopTime')  
        log.log_from_logger(rec, 'preyLocked')  
        log.log_from_logger(rec, 'nPreyLocked')
        log.log_from_logger(rec, 'seed')  
             
        if isprop(rec, 'probaHypothesis')
            entropy = ones(size(rec.probaHypothesis,1), 1) * -1;
            for iIteration = 1:size(rec.probaHypothesis,1)
                entropy(iIteration) = wentropy(rec.probaHypothesis(iIteration,:), 'shannon');
            end
            probaTrueHyp = rec.probaHypothesis(:,rec.hypothesisSelected);

            log.logit(entropy)
            log.logit(probaTrueHyp)      
        end
        
        remove_counter(isubF, length(subF))
    end
    
    [~, fname] = fileparts(rF{irF});
    saveFile = fullfile(analysisFolder, fname);
    log.save(saveFile)
    
    disp(' ')
end