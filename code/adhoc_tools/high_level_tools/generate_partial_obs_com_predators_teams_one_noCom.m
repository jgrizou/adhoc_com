function partialObsComPredatorsTeamsStructs = generate_partial_obs_com_predators_teams_one_noCom(allCardinalOrders, allComTypes, allComMappings, allComNoiseLevels)
%GENERATE_ALL_PARTIAL_OBS_COM_PREDATORS_TEAMS

[combinedParamStructs, nCombination] = combine_parameters(...
    'cardinalOrder', allCardinalOrders, ...
    'comType', allComTypes, ...
    'comMapping', allComMappings, ...
    'comNoiseLevel', allComNoiseLevels);

partialObsComPredatorsTeamsStructs = cell(nCombination, 1);
for i = 1:nCombination
        
        cardinalOrder = combinedParamStructs{i}.cardinalOrder;
        comType = combinedParamStructs{i}.comType;
        comMapping = combinedParamStructs{i}.comMapping;
        comNoiseLevel = combinedParamStructs{i}.comNoiseLevel;
        
        partialObsComPredatorsTeamsStructs{i} = cell(4,1);
        partialObsComPredatorsTeamsStructs{i}{1} = PartialObsAgent(cardinalOrder(1));
        partialObsComPredatorsTeamsStructs{i}{2} = PartialObsAgentCom(cardinalOrder(2), comType, comMapping, comNoiseLevel);
        partialObsComPredatorsTeamsStructs{i}{3} = PartialObsAgentCom(cardinalOrder(3), comType, comMapping, comNoiseLevel);
        partialObsComPredatorsTeamsStructs{i}{4} = PartialObsAgentCom(cardinalOrder(4), comType, comMapping, comNoiseLevel);

end
