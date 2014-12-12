function obsPredatorsTeamsStructs = generate_full_obs_predators_teams(allCardinalOrders)
%GENERATE_ALL_PARTIAL_OBS_COM_PREDATORS_TEAMS

[combinedParamStructs, nCombination] = combine_parameters(...
    'cardinalOrder', allCardinalOrders);

obsPredatorsTeamsStructs = cell(nCombination, 1);
for i = 1:nCombination
        
        cardinalOrder = combinedParamStructs{i}.cardinalOrder;
        
        obsPredatorsTeamsStructs{i} = cell(4,1);
        obsPredatorsTeamsStructs{i}{1} = AutoCardinalTaskAgent(cardinalOrder(1));
        obsPredatorsTeamsStructs{i}{2} = AutoCardinalTaskAgent(cardinalOrder(2));
        obsPredatorsTeamsStructs{i}{3} = AutoCardinalTaskAgent(cardinalOrder(3));
        obsPredatorsTeamsStructs{i}{4} = AutoCardinalTaskAgent(cardinalOrder(4));

end
