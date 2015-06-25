function pvalue = ttest_keys(dico, conditionOneName, conditionTwoName, dicoSeeds)
%TTEST_KEYS

intSeeds = intersect(dicoSeeds(conditionOneName), dicoSeeds(conditionTwoName));
c1values = get_values_at_keys_with_seeds(conditionOneName, intSeeds, dico, dicoSeeds);
c2values = get_values_at_keys_with_seeds(conditionTwoName, intSeeds, dico, dicoSeeds);

[~,pvalue] = ttest2(c1values, c2values);
