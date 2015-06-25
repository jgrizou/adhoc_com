function values = get_values_at_keys_with_seeds(key, intSeeds, d, s)
%GET_VALUES_AT_KEYS_WITH_SEED

[~,index,~] = intersect(s(key), intSeeds);

tmp = d(key);
values = tmp(index);