function domainStructHypothesis = generate_domain_hypothesis(simuInfo, seed)

% use the seed before each event that implies using a random generator

%% team of predators
init_random_seed(seed);
allCardinalOrders = generate_cardinal_orders(simuInfo.nCardinalConfiguration);

%
init_random_seed(seed);
switch simuInfo.predatorType
    
    case 'fullObs'
        allPredators = generate_full_obs_predators_teams(allCardinalOrders);
        
    case 'partialObs'
        allPredators = generate_partial_obs_predators_teams(allCardinalOrders);
        
    case 'partialObsCom'
        allComTypes = simuInfo.comType;
        allComMappings = generate_mappings(simuInfo.gridSize, simuInfo.nComMapping);
        allPredators = generate_partial_obs_com_predators_teams(...
            allCardinalOrders, ...
            allComTypes, ...
            allComMappings, ...
            simuInfo.comNoiseLevel);
        
   case 'partialObsComOneNoCom'
        allComTypes = simuInfo.comType;
        allComMappings = generate_mappings(simuInfo.gridSize, simuInfo.nComMapping);
        allPredators = generate_partial_obs_com_predators_teams_one_noCom(...
            allCardinalOrders, ...
            allComTypes, ...
            allComMappings, ...
            simuInfo.comNoiseLevel);        
        
    otherwise
        error(['predator type: ', simuInfo.predatorType, ' is unknown'])
end

%% prey
switch simuInfo.preyType
    
    case 'random'
        prey = {RandomPrey()};
        
    case 'escape'
        prey = {EscapingPrey()};
        
    otherwise
        error(['prey type: ', simuInfo.preyType, ' is unknown'])
end

%% locking state
init_random_seed(seed);
allLockingStates = generate_locking_states(simuInfo.gridSize, simuInfo.nLockingState);

%% geneare domains for all combinations
domainStructHypothesis = generate_all_domains(...
    simuInfo.gridSize, ...
    simuInfo.envNoiseLevel, ...
    allPredators, ...
    prey, ...
    allLockingStates);