simuInfo.predatorType = 'partialObsCom'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = 1;

simuInfo.comType = {'absolute'};
simuInfo.nComMapping = 1;

%
simuInfo.expType = 'adhoc'; %adhoc, team
simuInfo.adhocUseCom = true;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename;

