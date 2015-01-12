simuInfo.predatorType = 'partialObsCom'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = 1;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

simuInfo.comType = {'absolute'};
simuInfo.nComMapping = 1;

%
simuInfo.expType = 'adhoc'; %adhoc, team
simuInfo.adhocUseCom = true;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename(3:end);

