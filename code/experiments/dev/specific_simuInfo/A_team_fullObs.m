simuInfo.predatorType = 'fullObs'; % fullObs, partialObs, partialObsCom, partialObsComOneNoCom
simuInfo.nCardinalConfiguration = simuInfo.defaultNCardinalConfiguration;

simuInfo.nLockingState = simuInfo.defaultNLockingState;

%
simuInfo.expType = 'team'; %adhoc, team

%
[~, filename, ~] = fileparts(mfilename('fullpath'));
simuInfo.settingName = filename(3:end);