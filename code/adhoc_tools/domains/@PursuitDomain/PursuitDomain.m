classdef PursuitDomain < matlab.mixin.Copyable
    
    properties
        environment        
        maxErr = 1e-10;
        
        agents = {}
        agentsStates = []
        agentsMessages = []
        
        predatorsIdx = []
        preyIdx = []
        
        lockingState
                
    end
    
    methods
        function self = PursuitDomain(environment, lockingState)
            self.environment = environment;
            self.lockingState = lockingState;
        end
        
        function add_predator(self, predator)
            self.agents{end+1} = predator;
            id = length(self.agents);
            self.predatorsIdx(end+1,1) = id;
            predator.id = id;
            self.agentsStates(end+1,1) = 0;
            self.agentsMessages(end+1,1) = 0;
        end
        
        function add_prey(self, prey)
            if isempty(self.preyIdx)
                self.agents{end+1} = prey;
                id = length(self.agents);
                self.preyIdx = id;
                prey.id = id;
                self.agentsStates(end+1,1) = 0;
                self.agentsMessages(end+1,1) = 0;
            else
                warning('You can only have one prey')
            end
        end
        
        %%
        function init(self)
            % assign random states
            for i = 1:length(self.agents)
                self.set_agent_state(i,self.environment.get_random_state());
            end            
            %repeat while init not okay
            if ~self.check_states()
                self.init()
            end
        end
        
        function areStatesValid = check_states(self)
            areStatesValid = false;
            % check agents' states are different
            occupiedStates = self.get_occupied_states();
            if length(unique(occupiedStates)) ~= length(occupiedStates)
                return
            end
            %  if it wenty through it is valid
            areStatesValid = true;
        end
                
        %%
        function recorder = iterate(self, ordering, recorder)
            self.update_agents_messages();
            recorder.log_field('domainState', self.get_domain_state())

            agentsActions = self.collect_agents_actions(recorder); 
            self.apply_agents_actions(agentsActions, ordering)
            
            if ~self.check_states()
                error('something went wrong states are identical!!!')
            end
        end
        
        %%
        function update_agents_messages(self)
            self.clean_messages()
            for i = 1:length(self.agents)
                agent = self.agents{i};
                if ismethod(agent, 'compute_message')
                    self.add_message(i,agent.compute_message(self));
                end
            end
        end
        
        function add_message(self, agentIdx, agentMessage)
            self.agentsMessages(agentIdx) = agentMessage;
        end
        
        function agentMessage = get_message(self, agentIdx)
            agentMessage = self.agentsMessages(agentIdx);
        end
        
        function clean_messages(self)
            self.agentsMessages = zeros(length(self.agents),1);
        end
        
        function agentsMessages = get_all_messages(self)
            agentsMessages = self.agentsMessages;
        end
        
        function set_all_messages(self, agentsMessages)
            self.agentsMessages = agentsMessages;
        end
        
        %%
        function agentsActions = collect_agents_actions(self, recorder)
            agentsActions = zeros(length(self.agents), 1);
            for i = 1:length(self.agents)
                agentLog = Logger();
                agentsActions(i) = self.agents{i}.compute_action(self, agentLog);
                recorder.logit(agentLog)
            end
        end
        
        function agentsActionsProba = collect_agents_actions_proba(self, recorder)
            agentsActionsProba = zeros(length(self.agents), self.environment.nActions);
            for i = 1:length(self.agents)
                agentLog = Logger();
                agentsActionsProba(i, :) = self.agents{i}.compute_action_proba(self, agentLog);
                recorder.logit(agentLog)
            end
        end
        
        function apply_agents_actions(self, agentsActions, ordering)
            for i = 1:length(ordering)
                agentIdx = ordering(i);
                self.apply_agent_action(agentIdx, agentsActions(agentIdx))
            end
        end
        
        function apply_agent_action(self, agentIdx, action)            
            nextState = self.environment.eval_next_state_no_noise(self.get_agent_state(agentIdx), action);
            if ~self.is_state_occupied(nextState)
                self.set_agent_state(agentIdx, nextState);
            end
        end
        
        %%
        function ordering = generate_random_ordering(self)
            ordering = randperm(length(self.agents));
        end
        
        function ordering = generate_random_ordering_prey_last(self)
            ordering = self.predatorsIdx(randperm(length(self.predatorsIdx)));
            ordering(end+1) = self.preyIdx;
        end
        
        function preyState = get_prey_state(self)
            preyState = self.get_agent_state(self.preyIdx);
        end
        
        function predatorsStates = get_predators_states(self)
           predatorsStates = zeros(length(self.predatorsIdx), 1);
           for i = 1:length(self.predatorsIdx)
               predatorsStates(i) = self.get_agent_state(self.predatorsIdx(i));
           end
        end
        
        function state = get_agent_state(self, agentIdx)
            state = self.agentsStates(agentIdx);
        end
                
        function set_agent_state(self, agentIdx, state)
            self.agentsStates(agentIdx) = state;
        end

        %%
        function occupiedStates = get_occupied_states(self)
            occupiedStates = zeros(size(self.agentsStates));
            for i = 1:length(self.agents)
                occupiedStates(i) = self.get_agent_state(i);
            end
        end
        
        
        function isOccupied = is_state_occupied(self, state)
            if any(state == self.get_occupied_states())
                isOccupied = true;
            else
                isOccupied = false;
            end
        end
        
        function freeNeighborStates = get_free_neighbor_states(self, state)
            occupiedStates = self.get_occupied_states();
            neighborStates = self.environment.get_neighbor_states(state);
            freeNeighborStates = setdiff(neighborStates,occupiedStates);
        end
        
        %%
        function isLocked = is_prey_locked(self)
            if isempty(self.get_free_neighbor_states(self.get_prey_state()))
                isLocked = true;
            else
                isLocked = false;
            end
        end
        
        function isLocked = is_prey_locked_at_locking_state(self)
            isLocked = false;
            if self.is_prey_locked() && self.get_prey_state() == self.lockingState
                isLocked = true;
            end
        end
        
        %%
        function visibleStates = compute_visible_states(self, startState, visibleAreaActionSequence)
            visibleStates = zeros(size(visibleAreaActionSequence,1),2);
            for i = 1:size(visibleAreaActionSequence,1)
                state = startState;
                for j = 1:size(visibleAreaActionSequence,2)
                    state = self.environment.eval_next_state_no_noise(state, visibleAreaActionSequence(i,j));
                end
                visibleStates(i,:) = state;
            end
            visibleStates = unique(visibleStates);
        end

        %%
        function actionProba = compute_optimal_action_proba(self, initState, targetStateProba, obstacleProba)
            [optimalPolicy, ~]  = self.compute_optimal_policy(targetStateProba, obstacleProba);
            actionProba = full(optimalPolicy(initState,:));
        end
        
        function [optimalPolicy, MDP] = compute_optimal_policy(self, targetStateProba, obstacleProba)
            MDP = self.environment.get_noise_mdp_with_obstacle_and_reward(targetStateProba, obstacleProba);
            [~, optimalPolicy] = VI(MDP, self.maxErr);
        end
        
        %% load and save state
        
        function domainState = get_domain_state(self)
            domainState = struct;
            %predators states
            domainState.predatorsStates = zeros(length(self.predatorsIdx), 1);
            for i = self.predatorsIdx
                domainState.predatorsStates(i) = self.get_agent_state(i);
            end
            %prey state
            domainState.preyState = self.get_prey_state();
            %set message
            domainState.agentMessages = self.get_all_messages();
        end
        
        function load_domain_state(self, domainState)
            % loading must be done on the same domain (or a copy) such that
            % agents are in the same ordering
            %load predator state
            for i = self.predatorsIdx
                self.set_agent_state(i, domainState.predatorsStates(i));
            end
            %load prey state
            self.set_agent_state(self.preyIdx, domainState.preyState);
            %set message
            self.set_all_messages(domainState.agentMessages)
        end
             
        function logProbaNextDomainState = compute_log_proba_next_domain_state(self, nextDomainState, ordering)
            logProbaNextDomainState = -Inf;
            %simulate agent action given messages
            agentsActionsProba = self.collect_agents_actions_proba(Logger());
            noiseActionProba = self.environment.generate_all_actions_proba();
            %merged them so next step will be faster
            mergedAgentsActionsProba = agentsActionsProba * noiseActionProba;
            %generating all possible cases, here we assume there is 5 agents!!
            if size(agentsActionsProba, 1) ~= 5
                error('should be 5 agents here')
            end
            actionIdx = 1:self.environment.nActions;
            [x1,x2,x3,x4,x5] = ndgrid(actionIdx,actionIdx,actionIdx,actionIdx,actionIdx);
            actionsIndexes = [x1(:),x2(:),x3(:),x4(:),x5(:)];
            %go through all possible next states and add proba when similar
            for i = 1:size(actionsIndexes, 1)
                logProba = PursuitDomain.log_proba_from_action_indexe(mergedAgentsActionsProba, actionsIndexes(i, :));
                if ~isinf(logProba)                
                    domainCopy = copy(self);
                    for j = 1:length(ordering)
                        agentIdx = ordering(j);
                        domainCopy.apply_agent_action(agentIdx, actionsIndexes(i, agentIdx))
                    end
                    % if same domain state increase proba
                    if PursuitDomain.are_domain_states_equal(domainCopy.get_domain_state(), nextDomainState)
                        logProbaNextDomainState = add_lns(logProbaNextDomainState, logProba);
                    end
                end
            end
        end
        
        %%
        function draw(self)
            %draw grid
            self.environment.drawer.reset_colors()
            self.environment.drawer.draw()
            hold on
            %draw locking state
            self.environment.drawer.draw_dot(self.lockingState, get_nice_color('b'))
            %draw agent
            for i = 1:length(self.agents)
                self.agents{i}.draw(self);
            end
        end
        
    end
    
    methods(Static)
        
        function areEqual = are_domain_states_equal(domainState1, domainState2)
            areEqual = true;
            %predators
            if any(domainState1.predatorsStates ~= domainState2.predatorsStates)
                areEqual = false;
                return
            end
            %prey
            if domainState1.preyState ~= domainState2.preyState
                areEqual = false;
                return
            end
        end
        
        function logProba = log_proba_from_action_indexe(agentsActionsProba, actionsIndexe)
            logProba = 0;
            for i = 1:size(agentsActionsProba, 1)
                logProba = logProba + log(agentsActionsProba(i, actionsIndexe(i)));
            end
        end
        
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function copySelf = copyElement(self)
            % Make a shallow copy of all properties
            copySelf = copyElement@matlab.mixin.Copyable(self);
            % Make a deep copy of the class object that needs it
            for i = 1:length(self.agents)
                copySelf.agents{i} = copy(self.agents{i});
            end
        end
    end
end




