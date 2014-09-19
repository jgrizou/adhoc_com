

init_random_seed(seed);
gridSize = 7;
noiseLevel = 0.1;

comType = 'relative';

predators = {};
predators{end+1} = PartialObsAgentCom(1, comType);
predators{end+1} = PartialObsAgentCom(2, comType);
predators{end+1} = PartialObsAgentCom(3, comType);
predators{end+1} = PartialObsAgentCom(4, comType);

prey = EscapingPrey();
% prey = RandomPrey();

[domain, ~] = create_domain_with_seed(gridSize, noiseLevel, predators, prey, seed);

%%

cnt = 0;
while ~domain.is_prey_locked_at_locking_state()
    cnt = cnt + 1
    ordering = domain.generate_random_ordering_prey_last();
    domain.iterate(ordering)
    domain.draw()
    drawnow
end
domain.draw()