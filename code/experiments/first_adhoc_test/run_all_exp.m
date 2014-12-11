function run_all_exp(seed)

% %% adhoc
% rec = init_hypothesis_with_seed(seed);
% rec = run_adhoc_exp(rec);
% save_condor_rec(rec, 'adhocTeam')
% 
% 
% %% team
% rec = init_hypothesis_with_seed(seed);
% rec = run_team_exp(rec);
% save_condor_rec(rec, 'fullTeam')

%% baseline team nocom
rec = init_hypothesis_without_com(seed);
rec = run_team_exp(rec);
save_condor_rec(rec, 'fullTeamNoCom')