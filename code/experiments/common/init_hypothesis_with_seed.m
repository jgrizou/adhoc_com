function rec = init_hypothesis_with_seed(simuInfo, seed)

%% generate hypothesis
init_random_seed(seed);
domainStructHypothesis = generate_domain_hypothesis(simuInfo, seed);

%% select one domain struct with the adhoc
init_random_seed(seed); 
nHypothesis = length(domainStructHypothesis);
hypothesisSelected = randi(nHypothesis);

%% inint the domain - set the seed so it is the same init state for all domain with such seed
init_random_seed(seed); 
domain = create_domain_from_struct(domainStructHypothesis{hypothesisSelected});
domain.init()
initDomainState = domain.get_domain_state();

%% log init
rec = Logger();
rec.logit(seed)
rec.logit(domainStructHypothesis)
rec.logit(hypothesisSelected)
rec.logit(initDomainState)