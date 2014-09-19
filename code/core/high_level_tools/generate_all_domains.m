function allDomainStructs = generate_all_domains(allGridSize, allNoiseLevel, allPredators, allPreys, allLockingState)
%GENERATE_ALL_DOMAINS

allDomainStructs = {};

for iGridSize = 1:length(allGridSize)
    for iNoiseLevel = 1:length(allNoiseLevel)
        for iPredators = 1:length(allPredators)
            for iPreys = 1:length(allPreys)
                for iLockingState = 1:size(allLockingState,1)
                    
                    allDomainStructs{end+1} = struct;
                    allDomainStructs{end}.gridSize = allGridSize(iGridSize);
                    allDomainStructs{end}.noiseLevel = allNoiseLevel(iNoiseLevel);
                    allDomainStructs{end}.predators = allPredators{iPredators};
                    allDomainStructs{end}.prey = allPreys{iPreys};
                    allDomainStructs{end}.lockingState = allLockingState(iLockingState, :);
                    
                end 
            end 
        end     
    end
end