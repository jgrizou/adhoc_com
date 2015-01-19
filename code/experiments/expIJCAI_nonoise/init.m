[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

addpath(genpath(pathstr));
addpath(genpath(fullfile(pathstr, '../condor/')));
addpath(genpath(fullfile(pathstr, '../common/')));
addpath(genpath(fullfile(pathstr, '../../adhoc_tools/')));
addpath(genpath(fullfile(pathstr, '../../matlab_tools/')));

clear 'pathstr'

%%
% Change default figure stuff
set(0,'DefaultFigurePosition', [2210 541 839 672])
set(0,'DefaultAxesFontName', 'Courier')
set(0,'DefaultAxesFontSize', 14)
set(0,'DefaultAxesFontWeight','bold')
set(0,'DefaultAxesLineWidth', 2.5)
