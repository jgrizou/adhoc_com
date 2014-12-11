function rec = init_hypothesis_without_com(seed)

rec = init_hypothesis_with_seed(seed);

for i = 1:length(rec.domainStructHypothesis)
     for j = 1:length(rec.domainStructHypothesis{i}.predators)
         
         cardinal = rec.domainStructHypothesis{i}.predators{j}.cardinal;
         rec.domainStructHypothesis{i}.predators{j} = PartialObsAgent(cardinal);
         
     end
end


