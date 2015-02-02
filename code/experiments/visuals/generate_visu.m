[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

addpath(genpath(pathstr));
addpath(genpath(fullfile(pathstr, '../common/')));
addpath(genpath(fullfile(pathstr, '../../adhoc_tools/')));
addpath(genpath(fullfile(pathstr, '../../matlab_tools/')));

%%
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Courier')
DefaultAxesFontSize = 25;
set(0,'DefaultAxesFontSize', DefaultAxesFontSize)
set(0,'DefaultAxesFontWeight','bold')
set(0,'DefaultAxesLineWidth', 2.5)

defaultFontSize = 30;

figPos = [1800,50,1300,1000];

plotFolder = fullfile(pathstr, 'plots');
plotFormats = {'png', 'eps'};
savePlots = 1;

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
init_random_seed(0);
domain = create_domain(gridSize, noiseLevel, predators, prey);
domain.lockingState = 18;
domain.init()

domain.environment.drawer.fontSize = defaultFontSize;

%%
figure('position', figPos)
domain.draw()

plotFilenames = {'teamConfigRandom'};
if savePlots == 1
    save_all_images(plotFolder, plotFormats, plotFilenames)
    close all
end

%%
domain.set_agent_state(1,9)
domain.set_agent_state(2,3)
domain.set_agent_state(3,12)
domain.set_agent_state(4,24)
domain.set_agent_state(5,10)

figure('position', figPos)
domain.draw()

plotFilenames = {'teamConfigApproach'};
if savePlots == 1
    save_all_images(plotFolder, plotFormats, plotFilenames)
    close all
end


%%
domain.set_agent_state(1,17)
domain.set_agent_state(2,11)
domain.set_agent_state(3,19)
domain.set_agent_state(4,25)
domain.set_agent_state(5,18)

figure('position', figPos)
domain.draw()

plotFilenames = {'teamConfigCapture'};
if savePlots == 1
    save_all_images(plotFolder, plotFormats, plotFilenames)
    close all
end

%%
domain.set_agent_state(1,25)

figure('position', figPos)
domain.agents{1}.draw_visible_states(domain, get_nice_color('r'))

plotFilenames = {'visibleStatesMiddle'};
if savePlots == 1
    save_all_images(plotFolder, plotFormats, plotFilenames)
    close all
end

%%
domain.set_agent_state(1,2)

figure('position', figPos)
domain.agents{1}.draw_visible_states(domain, get_nice_color('r'))

plotFilenames = {'visibleStatesSide'};
if savePlots == 1
    save_all_images(plotFolder, plotFormats, plotFilenames)
    close all
end

%%
preyStateToConsider = [11,33,43,39];

for iPrey = 1:length(preyStateToConsider)
    preyState = preyStateToConsider(iPrey);
    
    domain.set_agent_state(1,preyState)
    domain.set_agent_state(2,preyState)
    domain.set_agent_state(3,preyState)
    domain.set_agent_state(4,preyState)
    domain.set_agent_state(5,preyState)

    figure('position', figPos)
    domain.environment.drawer.fontSize = defaultFontSize;
    domain.draw()

    domain.environment.drawer.fontSize = 50;
    roleSymbol = {'E', 'W', 'N', 'S'};
    for i = 1:4
        % 1,2,3,4 for +x, -x, +y, -y
        targetState = domain.agents{i}.compute_target_states_from_prey_states(domain, preyState);
        targetPosition = domain.environment.state_to_position(targetState);
        domain.environment.drawer.draw_square(targetPosition, [1,1,1], roleSymbol{i})
    end

    plotFilenames = {['targetStates_', num2str(preyState)]};
    if savePlots == 1
        save_all_images(plotFolder, plotFormats, plotFilenames)
        close all
    end

end

