clean
seed = 1;

%%
gridSize = 7;
noiseLevel = 0;

comType = 'relative';
comMapping = 1:gridSize^2;
comNoiseLevel = 0;

predators = {};
predators{end+1} = PartialObsAgentCom(1, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(2, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(3, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(4, comType, comMapping, comNoiseLevel);

prey = EscapingPrey();

%%
init_random_seed(seed);
domain = create_domain(gridSize, noiseLevel, predators, prey);
domain.init()

%%

tic
cnt = 0;
while ~domain.is_prey_locked_at_locking_state()
    cnt = cnt + 1
    ordering = domain.generate_random_ordering_prey_last();
    domain.iterate(ordering)
    domain.draw()
    drawnow
%     pause
end
domain.draw()
toc