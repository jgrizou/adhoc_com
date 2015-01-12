clean

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
resultFolder = fullfile(pathstr, 'results');

analysisFolder = fullfile(pathstr, 'analysis');
ensure_new_folder(analysisFolder)

rF = getfilenames(resultFolder);

maxIter = 200;

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
            continue
        end
                        
        runTime = sum(rec.loopTime); log.logit(runTime)
        
        time_to_capture = length(rec.loopTime); log.logit(time_to_capture)
        
        if isprop(rec, 'probaHypothesis')
            entropy = ones(maxIter, 1) * -1;
            probaTrueHyp = ones(maxIter, 1) * -1;
            for iIteration = 1:time_to_capture
                entropy(iIteration) = wentropy(rec.probaHypothesis(iIteration,:), 'shannon');
                probaTrueHyp(iIteration) = rec.probaHypothesis(iIteration,rec.hypothesisSelected);
            end
            entropy(time_to_capture:end) = entropy(time_to_capture);
            probaTrueHyp(time_to_capture:end) = probaTrueHyp(time_to_capture);

            log.logit(entropy)
            log.logit(probaTrueHyp)      
        end
        
        log.log_from_logger(rec, 'seed')        
        
        remove_counter(isubF, length(subF))
    end
    
    [~, fname] = fileparts(rF{irF});
    saveFile = fullfile(analysisFolder, fname);
    log.save(saveFile)
    
    disp(' ')
end