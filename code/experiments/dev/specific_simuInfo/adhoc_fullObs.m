simuInfo.predatorType = 'fullObs'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

%
simuInfo.expType = 'adhoc'; %adhoc, team
simuInfo.adhocUseCom = false;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename;