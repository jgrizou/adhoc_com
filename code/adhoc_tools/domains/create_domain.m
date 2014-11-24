function domain = create_domain(gridSize, noiseLevel, predators, prey)
%CREATE_DOMAIN

environment = ToroidalGridMDP(gridSize, noiseLevel);
lockingState = environment.get_random_state();
domain = PursuitDomain(environment, lockingState);

for i = 1:length(predators)
    domain.add_predator(predators{i});
end
domain.add_prey(prey);