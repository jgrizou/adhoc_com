clean 
seed = 1;

%%
init_random_seed(seed);

%% generate hypothesis
gridSize = 7;
noiseLevel = 0.2;

% teams of predators
allCardinalOrders = generate_cardinal_orders(2); % max 24
% allComTypes = {'absolute'};
allComTypes = {'absolute', 'relative'};
allComMappings = generate_mappings(gridSize, 2); % max too big
comNoiseLevel = 0.2;

allPredators = generate_partial_obs_com_predators_teams(allCardinalOrders, allComTypes, allComMappings, comNoiseLevel);

% prey
prey = {EscapingPrey()};

% locking state
allLockingStates = generate_locking_states(gridSize, 2); %max 49

% generate
domainStructHypothesis = generate_all_domains(gridSize, noiseLevel, allPredators, prey, allLockingStates);
nHypothesis = length(domainStructHypothesis);

%% select one domain struct with the adhoc
hypothesisSelected = randi(nHypothesis);
domain = create_domain_from_struct(domainStructHypothesis{hypothesisSelected});
domain.init()
initDomainState = domain.get_domain_state();

%%
adhocDomain = AdhocAgent.create_adhoc_domain(domainStructHypothesis, hypothesisSelected);
adhocDomain.load_domain_state(initDomainState)

% domain = create_domain_from_struct(domainStructHypothesis{hypothesisSelected});
% domain.load_domain_state(adhocDomain.get_domain_state())

%% log init
rec = Logger();
rec.logit(seed)
rec.logit(domainStructHypothesis)
rec.logit(hypothesisSelected)
rec.logit(initDomainState)

%%
cnt = 0;
while ~adhocDomain.is_prey_locked_at_locking_state()
    cnt = cnt + 1;
    add_counter(cnt)
    tic
    
    stepLog = Logger();
    
    %% iterate
    ordering = adhocDomain.generate_random_ordering_prey_last(); stepLog.logit(ordering);    
    adhocDomain.update_agents_messages(); % for now the order of messages does not matter
    
    
    %%here, need to do this for each hypothetic domain, take inspiration
    %%from AdhocAgent.update_hypothesis_proba
    [preyStateProba, allPreyStateProba] = PartialObsAgentCom.decode_all_agent_messages(adhocDomain);
    rec.log_in_cell('preyStateProba', preyStateProba)
    rec.log_in_cell('allPreyStateProba', allPreyStateProba)
    
    %% get domain state after message updated
    domainState = adhocDomain.get_domain_state(); rec.logit(domainState);

    %% collect and pally actions 
    agentsActions = adhocDomain.collect_agents_actions(stepLog);  
    adhocDomain.apply_agents_actions(agentsActions, ordering)
    
    adhocDomain.draw()
    drawnow
    
    %% update hypothesis proba
    adhocDomain.agents{1}.update_hypothesis_proba(domainState, adhocDomain.get_domain_state(), ordering)    
 
    rec.logit(stepLog)
    
    %% some morelog
    rec.log_field('logProbaHypothesis', adhocDomain.agents{1}.logProbaHypothesis)
    rec.log_field('probaHypothesis', adhocDomain.agents{1}.probaHypothesis)   
    
    loopTime = toc; rec.logit(loopTime)    
    remove_counter(cnt)
end





