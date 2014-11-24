function rec = run_adhoc_exp(rec)
%RUN_ADHOC_EXP

init_random_seed(rec.seed); 
adhocDomain = AdhocAgent.create_adhoc_domain(rec.domainStructHypothesis, rec.hypothesisSelected);
adhocDomain.load_domain_state(rec.initDomainState)

%%
cnt = 0;
while true
    cnt = cnt + 1;
    add_counter(cnt)
    tic
    
    stepLog = Logger();
    
    %% iterate
    ordering = adhocDomain.generate_random_ordering_prey_last(); stepLog.logit(ordering);    
    adhocDomain.update_agents_messages(); % for now the order of messages does not matter
    
    %% get domain state after message updated
    domainState = adhocDomain.get_domain_state(); 
    
    %% update proba from message
    logProbaHypothesisUpdateMessage = adhocDomain.agents{1}.compute_hypothesis_log_update_from_message(domainState);    
    adhocDomain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateMessage)

    %% collect and apply actions 
    agentsActions = adhocDomain.collect_agents_actions(stepLog);  
    adhocDomain.apply_agents_actions(agentsActions, ordering)
    
    %% update hypothesis proba
    logProbaHypothesisUpdateState = adhocDomain.agents{1}.compute_hypothesis_log_update_from_state(domainState, adhocDomain.get_domain_state(), ordering);    
    adhocDomain.agents{1}.update_hypothesis_proba(logProbaHypothesisUpdateState)  
    
    %% some log
    rec.logit(stepLog)
    rec.logit(domainState)
    rec.logit(logProbaHypothesisUpdateState)
    rec.logit(logProbaHypothesisUpdateMessage)
    rec.log_field('logProbaHypothesis', adhocDomain.agents{1}.logProbaHypothesis)
    rec.log_field('probaHypothesis', adhocDomain.agents{1}.probaHypothesis)      
                
    loopTime = toc; rec.logit(loopTime)    
    remove_counter(cnt)
    
    if adhocDomain.is_prey_locked_at_locking_state() || cnt > 100
       break 
    end
end