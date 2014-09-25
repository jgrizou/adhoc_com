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
    
    %% iterate
    ordering = adhocDomain.generate_random_ordering_prey_last(); rec.logit(ordering);    
    adhocDomain.update_agents_messages(); % for now the order of messages does not matter
    
    %% get domain state after message updated
    domainState = adhocDomain.get_domain_state(); rec.logit(domainState);

    %% collect and aplly actions 
    agentsActions = adhocDomain.collect_agents_actions();  
    adhocDomain.apply_agents_actions(agentsActions, ordering)      
    
    %% update hypothesis proba
    adhocDomain.agents{1}.update_hypothesis_proba(domainState, adhocDomain.get_domain_state(), ordering)    
 
    %% some morelog
    rec.log_field('logProbaHypothesis', adhocDomain.agents{1}.logProbaHypothesis)
    rec.log_field('probaHypothesis', adhocDomain.agents{1}.probaHypothesis)    
                
    loopTime = toc; rec.logit(loopTime)    
    remove_counter(cnt)
    
    if adhocDomain.is_prey_locked_at_locking_state() || cnt > 100
       break 
    end
end