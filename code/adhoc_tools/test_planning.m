clean
seed = 0;

%%
gridSize = 7;
noiseLevel = 0;

predators = {};
predators{end+1} = CardinalAgent(1);
predators{end+1} = CardinalAgent(2);
predators{end+1} = CardinalAgent(3);
predators{end+1} = CardinalAgent(4);

prey = EscapingPrey();

%%
init_random_seed(seed);
domain = create_domain(gridSize, noiseLevel, predators, prey);
domain.init()
%%

rec = Logger();

tic
cnt = 0;
while ~domain.is_prey_locked()
    cnt = cnt + 1
    stepLog = Logger();
    ordering = domain.generate_random_ordering_prey_last(); stepLog.logit(ordering)
    stepLog = domain.iterate(ordering, stepLog); rec.logit(stepLog)
    domain.draw()
    drawnow
%     pause
end
domain.draw()
toc