function allPartialObsPredatorsTeams = generate_all_partial_obs_predators_teams()
%GENERATE_ALL_PARTIAL_OBS_TEAMS

cardinalsOrder = perms(1:4);

allPartialObsPredatorsTeams = cell(size(cardinalsOrder, 1), 1);

for i = 1:size(cardinalsOrder, 1)
    allPartialObsPredatorsTeams{i} = cell(4,1);
    allPartialObsPredatorsTeams{i}{1} = PartialObsAgent(cardinalsOrder(i, 1));
    allPartialObsPredatorsTeams{i}{2} = PartialObsAgent(cardinalsOrder(i, 2));
    allPartialObsPredatorsTeams{i}{3} = PartialObsAgent(cardinalsOrder(i, 3));
    allPartialObsPredatorsTeams{i}{4} = PartialObsAgent(cardinalsOrder(i, 4));
end
