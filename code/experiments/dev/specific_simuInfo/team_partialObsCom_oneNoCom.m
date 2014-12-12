simuInfo.predatorType = 'partialObsComOneNoCom'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

simuInfo.comType = {'absolute', 'relative'};
simuInfo.nComMapping = simuInfo.defaultNComMapping;

%
simuInfo.expType = 'team'; %adhoc, team
simuInfo.adhocUseCom = true;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename;