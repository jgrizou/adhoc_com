simuInfo.predatorType = 'partialObs'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

%
simuInfo.expType = 'team'; %adhoc, team
simuInfo.adhocUseCom = false;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename;