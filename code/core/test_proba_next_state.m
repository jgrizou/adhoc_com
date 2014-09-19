

noiseValues = [0, 0.1, 0.2];
logP = zeros(size(noiseValues));
P = zeros(size(noiseValues));
time = zeros(size(noiseValues));

for i = 1:length(noiseValues)
    
    add_counter(i, length(noiseValues))
    
    tic
    init_random_seed(seed);

    gridSize = 7;
    noiseLevel = noiseValues(i);

    comType = 'relative';
    predators = {};
    predators{end+1} = PartialObsAgentCom(1, comType);
    predators{end+1} = PartialObsAgentCom(2, comType);
    predators{end+1} = PartialObsAgentCom(3, comType);
    predators{end+1} = PartialObsAgentCom(4, comType);
    
%     predators = {};
%     predators{end+1} = PartialObsAgent(1);
%     predators{end+1} = PartialObsAgent(2);
%     predators{end+1} = PartialObsAgent(3);
%     predators{end+1} = PartialObsAgent(4);

    prey = EscapingPrey();

    [domain, ~] = create_domain_with_seed(gridSize, noiseLevel, predators, prey, seed);

    copyDomain = copy(domain);

    ordering = domain.generate_random_ordering_prey_last();
    domain.iterate(ordering)

    m = domain.get_messages();
    s = domain.get_domain_state();
    
    logp = copyDomain.compute_log_proba_next_domain_state(s, m, ordering);

    
    logP(i) = logp;
    P(i) = exp(logp);
    time(i) = toc;

%     remove_counter(i, length(noiseValues))
end