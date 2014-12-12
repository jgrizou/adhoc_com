function partialObsPredatorsTeamsStructs = generate_partial_obs_predators_teams(allCardinalOrders)
%GENERATE_ALL_PARTIAL_OBS_COM_PREDATORS_TEAMS

[combinedParamStructs, nCombination] = combine_parameters(...
    'cardinalOrder', allCardinalOrders);

partialObsPredatorsTeamsStructs = cell(nCombination, 1);
for i = 1:nCombination
        
        cardinalOrder = combinedParamStructs{i}.cardinalOrder;
        
        partialObsPredatorsTeamsStructs{i} = cell(4,1);
        partialObsPredatorsTeamsStructs{i}{1} = PartialObsAgent(cardinalOrder(1));
        partialObsPredatorsTeamsStructs{i}{2} = PartialObsAgent(cardinalOrder(2));
        partialObsPredatorsTeamsStructs{i}{3} = PartialObsAgent(cardinalOrder(3));
        partialObsPredatorsTeamsStructs{i}{4} = PartialObsAgent(cardinalOrder(4));

end
