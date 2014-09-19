function allPartialObsComPredatorsTeams = generate_all_partial_obs_com_predators_teams()
%GENERATE_ALL_PARTIAL_OBS_COM_PREDATORS_TEAMS

cardinalsOrder = perms(1:4);
comTypes = {'absolute', 'relative'};

nTeams = size(cardinalsOrder, 1) * length(comTypes);
allPartialObsComPredatorsTeams = cell(nTeams, 1);

cnt = 0;
for i = 1:size(cardinalsOrder, 1)
    for j = 1:length(comTypes)
        cnt = cnt + 1;
        allPartialObsComPredatorsTeams{cnt} = cell(4,1);
        allPartialObsComPredatorsTeams{cnt}{1} = PartialObsAgentCom(cardinalsOrder(i, 1), comTypes{j});
        allPartialObsComPredatorsTeams{cnt}{2} = PartialObsAgentCom(cardinalsOrder(i, 2), comTypes{j});
        allPartialObsComPredatorsTeams{cnt}{3} = PartialObsAgentCom(cardinalsOrder(i, 3), comTypes{j});
        allPartialObsComPredatorsTeams{cnt}{4} = PartialObsAgentCom(cardinalsOrder(i, 4), comTypes{j});
    end
end
