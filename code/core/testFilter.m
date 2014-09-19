
rec = Logger();

seed = init_random_seed();
rec.logit(seed)

nStep = 50;
rec.logit(nStep)

%%
allGridSize = 7;
allNoiseLevel = 0;
% allPredators = generate_all_partial_obs_predators_teams();
allPredators = generate_all_partial_obs_com_predators_teams();
allPreys = {EscapingPrey()};
% allLockingState = generate_all_locking_states(allGridSize);
allLockingState = [2,2;2,6;4,4;6,2;6,6];

allDomainStructs = generate_all_domains(allGridSize, allNoiseLevel, allPredators, allPreys, allLockingState);

nHypothesis = length(allDomainStructs);

%% select one domain struct

iSelected = randi(nHypothesis); rec.logit(iSelected)
domainStructSelected = allDomainStructs{iSelected};
domainUsed = create_domain_from_struct(domainStructSelected, seed);
domainUsed.init()
domainState = domainUsed.get_domain_state(); rec.logit(domainState);

%%
logProbaHypothesis = zeros(1, nHypothesis);
for i = 1:nStep
    add_counter(i, nStep)
    tic
        
    ordering = domainUsed.generate_random_ordering_prey_last(); rec.logit(ordering);        
    domainUsed.iterate(ordering)    
    domainState = domainUsed.get_domain_state(); rec.logit(domainState);
    
    agentMessages = domainUsed.get_messages();
    
    for j = 1:nHypothesis
        add_counter(j, nHypothesis)        
        if ~isinf(logProbaHypothesis(j))
            hypDomain = create_domain_from_struct(allDomainStructs{j}, seed);
            hypDomain.load_domain_state(rec.domainState{end-1});
            logProbaHypothesis(j) = logProbaHypothesis(j) + hypDomain.compute_log_proba_next_domain_state(rec.domainState{end}, agentMessages, ordering);
        end
        remove_counter(j, nHypothesis)
    end
    rec.logit(logProbaHypothesis)
    
    loopTime = toc;
    rec.logit(loopTime)
    
    remove_counter(i, nStep)
end














