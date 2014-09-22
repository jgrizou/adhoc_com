communicationTypes = {'action', 'cardinal'};
comType = communicationTypes{randi(length(communicationTypes))}; rec.logit(comType);
comMapping = randperm(4); rec.logit(comMapping);

predators = {};
predators{end+1} = CardinalTaskAgentCom(1, NSstucker, comType, comMapping);
predators{end+1} = CardinalTaskAgentCom(2, ~NSstucker, comType, comMapping);
predators{end+1} = CardinalTaskAgentCom(3, WEstucker, comType, comMapping);
predators{end+1} = CardinalTaskAgentCom(4, ~WEstucker, comType, comMapping);