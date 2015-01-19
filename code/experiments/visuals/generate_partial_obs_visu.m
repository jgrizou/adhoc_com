[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

addpath(genpath(pathstr));
addpath(genpath(fullfile(pathstr, '../common/')));
addpath(genpath(fullfile(pathstr, '../../adhoc_tools/')));
addpath(genpath(fullfile(pathstr, '../../matlab_tools/')));

clear 'pathstr'

%%
seed = 0;

%%
gridSize = 7;
noiseLevel = 0;

comType = 'relative';
comMapping = 1:gridSize^2;
comNoiseLevel = 0;

predators = {};
predators{end+1} = PartialObsAgentCom(1, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(2, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(3, comType, comMapping, comNoiseLevel);
predators{end+1} = PartialObsAgentCom(4, comType, comMapping, comNoiseLevel);

prey = EscapingPrey();

%%
init_random_seed(seed);
domain = create_domain(gridSize, noiseLevel, predators, prey);
domain.lockingState = 18;
domain.init()

%%
domain.set_agent_state(1,9)
domain.set_agent_state(2,3)
domain.set_agent_state(3,12)
domain.set_agent_state(4,24)
domain.set_agent_state(5,10)


domain.draw()

% domain.agents{1}.draw_visible_states(domain, get_nice_color('r'))

