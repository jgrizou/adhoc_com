

availableTypes = {'absolute', 'relative'};
comType = availableTypes{randi(length(availableTypes))}; rec.logit(comType);

predators = {};
predators{end+1} = PartialObsAgentCom(comType);
predators{end+1} = PartialObsAgentCom(comType);
predators{end+1} = PartialObsAgentCom(comType);
predators{end+1} = PartialObsAgentCom(comType);