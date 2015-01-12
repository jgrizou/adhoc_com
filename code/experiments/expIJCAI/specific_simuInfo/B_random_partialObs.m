simuInfo.predatorType = 'partialObs'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

%
simuInfo.expType = 'random'; %adhoc, team, random

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename(3:end);