rec = Logger();

%%
rec.logit(seed);
init_random_seed(seed);

%%
maxIter = 250; rec.logit(maxIter);

%%
NSstucker = randi([0,1]); rec.logit(NSstucker);
WEstucker = randi([0,1]); rec.logit(WEstucker);