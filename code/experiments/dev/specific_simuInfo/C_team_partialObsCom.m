simuInfo.predatorType = 'partialObsCom'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

simuInfo.comType = {'absolute', 'relative'};
simuInfo.nComMapping = simuInfo.defaultNComMapping;

%
simuInfo.expType = 'team'; %adhoc, team

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename(3:end);