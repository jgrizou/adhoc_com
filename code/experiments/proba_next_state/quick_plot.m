


figure
load('/home/jgrizou/Dropbox/adhoc/code/experiments/proba_next_state/analysis/escape.mat')
errorbar(log.meanProbaGoal, log.stdProbaGoal, 'r')

xlabel('iteration')
ylabel('proba of correct hypothesis')
title('escape prey')

figure
load('/home/jgrizou/Dropbox/adhoc/code/experiments/proba_next_state/analysis/random.mat')
errorbar(log.meanProbaGoal, log.stdProbaGoal, 'b')

xlabel('iteration')
ylabel('proba of correct hypothesis')
title('random prey')

