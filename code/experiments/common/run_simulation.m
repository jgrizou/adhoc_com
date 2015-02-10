function rec = run_simulation(rec, simuInfo)

init_random_seed(rec.seed);

%%
switch simuInfo.expType
    
    case 'adhoc'
        domain = AdhocAgent.create_adhoc_domain(rec.domainStructHypothesis, rec.hypothesisSelected);
    
    case 'adhoccom'
        domain = AdhocAgentCom.create_adhoc_com_domain(rec.domainStructHypothesis, rec.hypothesisSelected);
        
    case 'team'
        domain = create_domain_from_struct(rec.domainStructHypothesis{rec.hypothesisSelected});
        
    case 'random'        
        domainStruct = rec.domainStructHypothesis{rec.hypothesisSelected};
        domainStruct.predators{1} = RandomAgent();
        domain = create_domain_from_struct(domainStruct);
        
    otherwise
        error(['exp type:', simuInfo.expType, ' is unknown'])
        
end

domain.load_domain_state(rec.initDomainState)

%%
nPreyLocked = 0;
newSeed = rec.seed; %used when reseting the setup when prey captured
for cnt = 1:simuInfo.maxIteration
    
    add_counter(cnt, simuInfo.maxIteration)
    tic
    
    %%
    stepLog = Logger();
    
    %% iterate
    ordering = domain.generate_random_ordering_prey_last(); stepLog.logit(ordering);
    domain.update_agents_messages(); % for now the order of messages does not matter
    
    %% get domain state after message updated
    domainState = domain.get_domain_state();
    
    %% update proba from message, only for adhoc mode
    if strcmp(simuInfo.expType, 'adhoc') || strcmp(simuInfo.expType, 'adhoccom')
        if simuInfo.adhocUseCom
            logProbaHypothesisUpdateMessage = domain.agents{1}.compute_hypothesis_log_update_from_message(domainState);
            domain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateMessage)
        end
    end
    
    %% collect and apply actions
    agentsActions = domain.collect_agents_actions(stepLog);
    domain.apply_agents_actions(agentsActions, ordering)
    
    %% update hypothesis proba, only for adhoc mode
    if strcmp(simuInfo.expType, 'adhoc')  || strcmp(simuInfo.expType, 'adhoccom')
        if simuInfo.adhocUseObs
            logProbaHypothesisUpdateState = domain.agents{1}.compute_hypothesis_log_update_from_state(domainState, domain.get_domain_state(), ordering);
            domain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateState)
        end
    end
    
    %% some log
    rec.logit(stepLog)
    rec.logit(domainState)
    
    %% specific logs, only for adhoc mode
    if strcmp(simuInfo.expType, 'adhoc') || strcmp(simuInfo.expType, 'adhoccom')
        rec.log_field('logProbaHypothesis', domain.agents{1}.logProbaHypothesis)
        rec.log_field('probaHypothesis', domain.agents{1}.probaHypothesis)
        
        if simuInfo.adhocUseCom
            rec.logit(logProbaHypothesisUpdateMessage)
        end
        
        if simuInfo.adhocUseObs
            rec.logit(logProbaHypothesisUpdateState)
        end
    end
    
    %% check if prey capture, reset environment but do not reset hypothesis proba
    if domain.is_prey_locked_at_locking_state()
        preyLocked = 1;
        nPreyLocked = nPreyLocked +1;
        newSeed = rec.seed + nPreyLocked;
        
        %% reinit the domain - set the seed so it is the same init state each subscequent task
        %save current domain state for the record
        domainState = domain.get_domain_state();
        rec.logit(domainState)
        % generate new domain state
        init_random_seed(newSeed); 
        tmpDomain = create_domain_from_struct(rec.domainStructHypothesis{rec.hypothesisSelected});
        tmpDomain.init()
        % load it
        domain.load_domain_state(tmpDomain.get_domain_state())        
    else
        preyLocked = 0;
    end
    rec.logit(preyLocked)
    rec.logit(nPreyLocked)
    rec.logit(newSeed)
    
    %%
    loopTime = toc; rec.logit(loopTime)
    remove_counter(cnt, simuInfo.maxIteration)
end

%save current domain state for the record
domainState = domain.get_domain_state();
rec.logit(domainState)













