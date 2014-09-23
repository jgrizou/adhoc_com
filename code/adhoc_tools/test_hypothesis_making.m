
init_random_seed(seed);

%% generate hypothesis
gridSize = 7;
noiseLevel = 0;

% teams of predators
allCardinalOrders = generate_cardinal_orders(5);
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

%% select one domain struct

iSelected = randi(nHypothesis); 
domainStructSelected = domainStructHypothesis{iSelected};
domain = create_domain_from_struct(domainStructSelected);
domain.init()
domainState = domain.get_domain_state();


%% a new domain with the adhoc

adhocDomainStruct = domainStructSelected;
adhocDomainStruct.predators{1} = AdhocAgent(domainStructHypothesis);
adhocDomain = create_domain_from_struct(adhocDomainStruct);


%%
rec = Logger();
rec.logit(domainState);

nStep = 50;

logProbaHypothesis = zeros(1, nHypothesis);
for i = 1:nStep
    add_counter(i, nStep)
    tic
    

        
    ordering = domain.generate_random_ordering_prey_last(); rec.logit(ordering);
    
    %% iterate
    domain.update_agents_messages(); % for now the order of messages does not matter
    agentsActions = domain.collect_agents_actions();
    
    %% 
    trueAgentActionProba = domain.agents{1}.compute_action_proba(domain); rec.logit(trueAgentActionProba);
    
    adhocDomain.load_domain_state(domainState); 
    adhocDomain.set_messages(domain.get_messages())
    adhocAgentActionProba = adhocDomain.agents{1}.compute_action_proba(adhocDomain); rec.logit(adhocAgentActionProba);
   
    %%    
    domain.apply_agents_actions(agentsActions, ordering)
              
    domainState = domain.get_domain_state(); rec.logit(domainState);    
    agentMessages = domain.get_messages();
    
    for j = 1:nHypothesis
        add_counter(j, nHypothesis)        
        if ~isinf(logProbaHypothesis(j))
            hypDomain = create_domain_from_struct(domainStructHypothesis{j});
            hypDomain.load_domain_state(rec.domainState{end-1});
            logProbaHypothesis(j) = logProbaHypothesis(j) + hypDomain.compute_log_proba_next_domain_state(rec.domainState{end}, agentMessages, ordering);
        end
        remove_counter(j, nHypothesis)
    end
            
    rec.logit(logProbaHypothesis)
    rec.log_field('probaHypothesis', log_normalize_row(logProbaHypothesis))    
            
    %%
    adhocDomain.agents{1}.update_hypothesis_proba(logProbaHypothesis);
    
    %%
    loopTime = toc;
    rec.logit(loopTime)
    
    remove_counter(i, nStep)
end


%%
subplot(3,1,1)
imagesc(rec.trueAgentActionProba')
subplot(3,1,2)
imagesc(rec.adhocAgentActionProba')
subplot(3,1,3)
plot(rec.probaHypothesis)




