simuInfo.predatorType = 'partialObsCom'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = 1;

simuInfo.nLockingState = 1;

simuInfo.comType = {'absolute', 'relative'};
simuInfo.nComMapping = simuInfo.defaultNComMapping;

%
simuInfo.expType = 'adhoc'; %adhoc, team
simuInfo.adhocUseCom = true;
simuInfo.adhocUseObs = true;

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename;

