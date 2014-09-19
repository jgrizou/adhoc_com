function [domain, seed] = create_domain_with_seed(gridSize, noiseLevel, predators, prey, seed)

if nargin < 5
    seed = init_random_seed();
else
    init_random_seed(seed);
end

domain = create_domain(gridSize, noiseLevel, predators, prey);

domain.init()

