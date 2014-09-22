%% init domain
[domain, ~] = create_domain_with_seed(gridSize, predators, prey, seed); rec.logit(domain);

%% run
iterations = 0;
while ~domain.is_prey_locked()
    add_counter(iterations, maxIter)  
    iterations = iterations + 1;
    domain.iterate()
    if iterations > maxIter
        break
    end
    remove_counter(iterations, maxIter)  
end
rec.logit(iterations)



