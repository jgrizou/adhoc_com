function rec = run_simulation(rec, simuInfo)

init_random_seed(rec.seed);

%%
switch simuInfo.expType
    
    case 'adhoc'
        domain = AdhocAgent.create_adhoc_domain(rec.domainStructHypothesis, rec.hypothesisSelected);
        
    case 'team'
        domain = create_domain_from_struct(rec.domainStructHypothesis{rec.hypothesisSelected});
        
    otherwise
        error(['exp type:', simuInfo.expType, ' is unknown'])
        
end

domain.load_domain_state(rec.initDomainState)

%%
cnt = 0;
while true
    cnt = cnt + 1;
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
    if strcmp(simuInfo.expType, 'adhoc')
        if simuInfo.adhocUseCom
            logProbaHypothesisUpdateMessage = domain.agents{1}.compute_hypothesis_log_update_from_message(domainState);
            domain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateMessage)
        end
    end
    
    %% collect and apply actions
    agentsActions = domain.collect_agents_actions(stepLog);
    domain.apply_agents_actions(agentsActions, ordering)
    
    %% update hypothesis proba, only for adhoc mode
    if strcmp(simuInfo.expType, 'adhoc')
        if simuInfo.adhocUseObs
            logProbaHypothesisUpdateState = domain.agents{1}.compute_hypothesis_log_update_from_state(domainState, domain.get_domain_state(), ordering);
            domain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateState)
        end
    end
    
    %% some log
    rec.logit(stepLog)
    rec.logit(domainState)
    
    %% specific logs, only for adhoc mode
    if strcmp(simuInfo.expType, 'adhoc')
        rec.log_field('logProbaHypothesis', domain.agents{1}.logProbaHypothesis)
        rec.log_field('probaHypothesis', domain.agents{1}.probaHypothesis)
        
        if simuInfo.adhocUseCom
            rec.logit(logProbaHypothesisUpdateMessage)
        end
        
        if simuInfo.adhocUseObs
            rec.logit(logProbaHypothesisUpdateState)
        end
    end
    
    %%
    loopTime = toc; rec.logit(loopTime)
    remove_counter(cnt, simuInfo.maxIteration)
    
    if domain.is_prey_locked_at_locking_state() || cnt >= simuInfo.maxIteration
        domainState = domain.get_domain_state();
        rec.logit(domainState)
        break
    end
end
