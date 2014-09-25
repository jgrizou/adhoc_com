function run_all_exp(seed)

initRec = init_hypothesis_with_seed(seed);

%% adhoc
rec = copy(initRec);
rec = run_adhoc_exp(rec);
save_condor_rec(rec, 'adhocTeam')


%% team
rec = copy(initRec);
rec = run_team_exp(rec);
save_condor_rec(rec, 'fullTeam')