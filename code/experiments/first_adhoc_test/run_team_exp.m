function rec = run_team_exp(rec)
%RUN_TEAM_EXP

init_random_seed(rec.seed); 
domain = create_domain_from_struct(rec.domainStructHypothesis{rec.hypothesisSelected});
domain.load_domain_state(rec.initDomainState)

%%
cnt = 0;
while true
    cnt = cnt + 1;
    add_counter(cnt)
    tic
        
    %% iterate
    ordering = domain.generate_random_ordering_prey_last(); rec.logit(ordering);    
    domain.update_agents_messages(); % for now the order of messages does not matter
    
    %% get domain state after message updated
    domainState = domain.get_domain_state(); rec.logit(domainState);

    %% collect and aplly actions 
    agentsActions = domain.collect_agents_actions();  
    domain.apply_agents_actions(agentsActions, ordering)   
                     
    loopTime = toc; rec.logit(loopTime)    
    remove_counter(cnt)
    
    if domain.is_prey_locked_at_locking_state() || cnt > 100
       break 
    end
end

