
%%
gridSize = 7;
noiseLevel = 0;


predators = {};
predators{end+1} = CardinalAgent(1);
predators{end+1} = CardinalAgent(2);
predators{end+1} = CardinalAgent(3);
predators{end+1} = CardinalAgent(4);

% prey = EscapingPrey();
prey = RandomPrey();

[domain, ~] = create_domain_with_seed(gridSize, noiseLevel, predators, prey, seed);
%%

cnt = 0;
while ~domain.is_prey_locked()
    cnt = cnt + 1
    ordering = domain.generate_random_ordering_prey_last();
    domain.iterate(ordering)
    domain.draw()
    drawnow
%     pause
end
domain.draw()


%%

% p1 = EscapingPrey(domain);
% domain.add_prey(p1);
%
% a1 = CardinalAgent(domain, 1);
% domain.add_agent(a1);
%
% a2 = CardinalAgent(domain, 2);
% domain.add_agent(a2);
%
% a3 = CardinalAgent(domain, 3);
% domain.add_agent(a3);
%
% a4 = CardinalAgent(domain, 4);
% domain.add_agent(a4);
%
% domain.init()
%%
% p1.state = [2,2];
% a1.state = [3,2];
% a2.state = [1,2];
% a3.state = [1,3];
% a4.state = [2,1];



