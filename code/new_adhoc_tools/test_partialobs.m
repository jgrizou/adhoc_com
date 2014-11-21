clean
seed = 0;

%%
gridSize = 7;
noiseLevel = 0;

predators = {};
predators{end+1} = PartialObsAgent(1);
predators{end+1} = PartialObsAgent(2);
predators{end+1} = PartialObsAgent(3);
predators{end+1} = PartialObsAgent(4);

prey = EscapingPrey();

%%
init_random_seed(seed);
domain = create_domain(gridSize, noiseLevel, predators, prey);
domain.init()

%%

rec = Logger()

tic
cnt = 0;
domain.draw()
while ~domain.is_prey_locked_at_locking_state()
    cnt = cnt + 1
    
    stepLog = Logger();
    ordering = domain.generate_random_ordering_prey_last(); stepLog.logit(ordering)
    stepLog = domain.iterate(ordering, stepLog); rec.logit(stepLog)
    
    domain.draw()
    drawnow
end
domain.draw()
toc
