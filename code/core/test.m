init
clean

%%
gridSize = 5;
nActions = 5;

environment = ToroidalGrid(gridSize,nActions);
lockingState = environment.get_random_state();

domain = PursuitDomain(environment, lockingState);

%%


a1 = CardinalTaskAgent(domain, 1, true);
domain.add_predator(a1);

a2 = CardinalTaskAgent(domain, 2, false);
domain.add_predator(a2);

a3 = CardinalTaskAgent(domain, 3, true);
domain.add_predator(a3);

a4 = CardinalTaskAgent(domain, 4, false);
domain.add_predator(a4);

p1 = EscapingPrey(domain);
% p1 = RandomAgent(domain, get_nice_color('g'));
domain.add_prey(p1);

domain.init()

%%

domain.draw()
cnt = 0;
while ~domain.is_prey_locked()
    cnt = cnt + 1
    
    ordering = domain.get_random_ordering();
    agentsActions = domain.collect_agents_actions(ordering);
    domain.apply_agents_actions(agentsActions, ordering)
%     domain.draw()
%     drawnow
%     pause
end
domain.draw()


%%

% p1 = EscapingPrey(domain);
% domain.add_prey(p1);
%
% a1 = CardinalAgent(domain, 1);
% domain.add_agent(a1);
%
% a2 = CardinalAgent(domain, 2);
% domain.add_agent(a2);
%
% a3 = CardinalAgent(domain, 3);
% domain.add_agent(a3);
%
% a4 = CardinalAgent(domain, 4);
% domain.add_agent(a4);
%
% domain.init()
%%
% p1.state = [2,2];
% a1.state = [3,2];
% a2.state = [1,2];
% a3.state = [1,3];
% a4.state = [2,1];



