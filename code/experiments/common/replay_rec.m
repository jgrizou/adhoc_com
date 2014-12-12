function replay_rec(rec)


domain = create_domain_from_struct(rec.domainStructHypothesis{rec.hypothesisSelected});

nSteps = length(rec.domainState);
for i = 1:nSteps
    
    add_counter(i, nSteps)
    
    clf
    domain.load_domain_state(rec.domainState{i})
    domain.draw()
    drawnow
    pause
    
    remove_counter(i, nSteps)
end