clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

% resultFolder = fullfile(pathstr, '..', 'expIJCAI_nonoise', 'analysis');
resultFolder = fullfile(pathstr, '..', 'expIJCAI', 'analysis');


rF = getfilenames(resultFolder, 'refiles', '*.mat');

rec = Logger();
for irF = 1:length(rF)
    
    load(rF{irF})
    
    [~,methodName,~] = fileparts(rF{irF});
    rec.logit(methodName)
    rec.log_in_cell('seed', log.seed)
    rec.log_in_cell('nPreyLocked', log.nPreyLocked(end,:))
    
    timeToFirstPrey = zeros(size(log.nPreyLocked,2), 1);
    timeToSecondPrey = zeros(size(log.nPreyLocked,2), 1);
    for i = 1:size(log.nPreyLocked,2)
        t = find(log.preyLocked(:,i), 1);
        if t
            timeToFirstPrey(i) = t;
        else
            timeToFirstPrey(i) = 200;
        end
        ts = diff(find(log.preyLocked(:,i)));
        if length(ts) >= 1
            timeToSecondPrey(i) = ts(1);
        else
            timeToSecondPrey(i) = 200;
        end
    end
    rec.log_in_cell('timeToFirstPrey', timeToFirstPrey)
    rec.log_in_cell('timeToSecondPrey', timeToSecondPrey)

    
end

s = containers.Map(rec.methodName, rec.seed);
d = containers.Map(rec.methodName, rec.nPreyLocked);
t = containers.Map(rec.methodName, rec.timeToFirstPrey);
ts = containers.Map(rec.methodName, rec.timeToSecondPrey);

%%
seeds = intersect(s('team_fullObs'), s('adhoc_fullObs')); 
values1 = get_values_at_keys_with_seeds('team_fullObs', seeds, t, s);
values2 = get_values_at_keys_with_seeds('adhoc_fullObs', seeds, t, s);
mean(values2 - values1)
std(values2 - values1)

seeds = intersect(s('team_partialObsCom_oneMuted'), s('adhoc_partialObsCom')); 
values1 = get_values_at_keys_with_seeds('team_partialObsCom_oneMuted', seeds, t, s);
values2 = get_values_at_keys_with_seeds('adhoc_partialObsCom', seeds, t, s);
mean(values2 - values1)
std(values2 - values1)

%%
seeds = intersect(s('team_fullObs'), s('adhoc_fullObs')); 
values1 = get_values_at_keys_with_seeds('team_fullObs', seeds, ts, s);
values2 = get_values_at_keys_with_seeds('adhoc_fullObs', seeds, ts, s);
mean(values2 - values1)
std(values2 - values1)

seeds = intersect(s('team_partialObsCom_oneMuted'), s('adhoc_partialObsCom')); 
values1 = get_values_at_keys_with_seeds('team_partialObsCom_oneMuted', seeds, ts, s);
values2 = get_values_at_keys_with_seeds('adhoc_partialObsCom', seeds, ts, s);
mean(values2 - values1)
std(values2 - values1)


%%
clc
pvalue = ttest_keys(d, 'team_fullObs', 'team_partialObs', s)
pvalue = ttest_keys(d, 'team_fullObs', 'team_partialObsCom', s)

%%
clc
pvalue = ttest_keys(d, 'team_fullObs', 'adhoc_fullObs', s)

%%
clc
pvalue = ttest_keys(d, 'team_partialObsCom', 'adhoc_partialObsCom', s)
pvalue = ttest_keys(d, 'adhoc_partialObsCom', 'team_partialObsCom_oneNoCom', s)
pvalue = ttest_keys(d, 'adhoc_partialObsCom', 'team_partialObsCom_oneMuted', s)

%%
clc
pvalue = ttest_keys(t, 'team_fullObs', 'team_partialObs', s)
pvalue = ttest_keys(t, 'team_fullObs', 'team_partialObsCom', s)

%%
clc
pvalue = ttest_keys(t, 'team_fullObs', 'adhoc_fullObs', s)

%%
clc
pvalue = ttest_keys(t, 'team_partialObsCom', 'adhoc_partialObsCom', s)
pvalue = ttest_keys(t, 'adhoc_partialObsCom', 'team_partialObsCom_oneNoCom', s)
pvalue = ttest_keys(t, 'adhoc_partialObsCom', 'team_partialObsCom_oneMuted', s)