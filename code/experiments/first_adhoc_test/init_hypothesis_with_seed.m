function rec = init_hypothesis_with_seed(seed)

init_random_seed(seed); 

%% generate hypothesis
gridSize = 7;
noiseLevel = 0;

% teams of predators
allCardinalOrders = generate_cardinal_orders(10);
allComTypes = {'absolute', 'relative'};
allComMappings = generate_mappings(gridSize, 1);
comNoiseLevel = 0;

allPredators = generate_partial_obs_com_predators_teams(allCardinalOrders, allComTypes, allComMappings, comNoiseLevel);

% prey
prey = {EscapingPrey()};

% locking state
allLockingStates = generate_locking_states(gridSize, 4);

% generate
domainStructHypothesis = generate_all_domains(gridSize, noiseLevel, allPredators, prey, allLockingStates);
nHypothesis = length(domainStructHypothesis);

%% select one domain struct with the adhoc
hypothesisSelected = randi(nHypothesis);
domain = create_domain_from_struct(domainStructHypothesis{hypothesisSelected});
domain.init()
initDomainState = domain.get_domain_state();

%% log init
rec = Logger();
rec.logit(seed)
rec.logit(domainStructHypothesis)
rec.logit(hypothesisSelected)
rec.logit(initDomainState)