classdef PursuitDomain < matlab.mixin.Copyable
    
    properties
        environment
        
        noiseLevel
        maxErr = 1e-10;
        
        agents = {}
        agentsStates = []
        
        predatorsIdx = []
        preyIdx = []
        
        lockingState
        
        agentsMessages
        
    end
    
    methods
        function self = PursuitDomain(environment, lockingState, noiseLevel)
            self.environment = environment;
            self.lockingState = lockingState;
            self.noiseLevel = noiseLevel;
        end
        
        function add_predator(self, predator)
            self.agents{end+1} = predator;
            id = length(self.agents);
            self.predatorsIdx(end+1) = id;
            predator.id = id;
            self.agentsStates(end+1,:) = zeros(1,2);
        end
        
        function add_prey(self, prey)
            if isempty(self.preyIdx)
                self.agents{end+1} = prey;
                id = length(self.agents);
                self.preyIdx = id;
                prey.id = id;
                self.agentsStates(end+1,:) = zeros(1,2);
            else
                warning('You can only have one prey')
            end
        end
        
        %%
        function iterate(self, ordering)
            self.update_agents_messages(); % for now the order of messages does not matter
            agentsActions = self.collect_agents_actions();
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
        
        function add_message(self, agentIdx, message)
            self.agentsMessages{agentIdx} = message;
        end
        
        function clean_messages(self)
            self.agentsMessages = {};
        end
        
        function agentsMessages = get_messages(self)
            agentsMessages = self.agentsMessages;
        end
        
        function set_messages(self, agentsMessages)
            self.agentsMessages = agentsMessages;
        end
        
        %%
        function agentsActions = collect_agents_actions(self)
            agentsActions = zeros(length(self.agents), 1);
            for i = 1:length(self.agents)
                agentsActions(i) = self.agents{i}.compute_action(self);
            end
        end
        
        function agentsActionsProba = collect_agents_actions_proba(self)
            agentsActionsProba = zeros(length(self.agents), self.environment.nActions);
            for i = 1:length(self.agents)
                agentsActionsProba(i, :) = self.agents{i}.compute_action_proba(self);
            end
        end
        
        function apply_agents_actions(self, agentsActions, ordering)
            for i = ordering
                self.apply_agent_action(i, agentsActions(i))
            end
        end
        
        function apply_agent_action(self, agentIdx, action)
            nextState = self.environment.eval_next_state(self.get_agent_state(agentIdx), action);
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
        
        function state = get_agent_state(self, agentIdx)
            state = self.agentsStates(agentIdx, :);
        end
        
        function set_agent_state(self, agentIdx, state)
            self.agentsStates(agentIdx, :) = state;
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
            if size(unique(occupiedStates, 'rows'), 1) ~= size(occupiedStates,1)
                return
            end
            %  if it wenty through it is valid
            areStatesValid = true;
        end
        
        %%
        function occupiedStates = get_occupied_states(self)
            occupiedStates = zeros(length(self.agents), 2);
            for i = 1:length(self.agents)
                occupiedStates(i, :) = self.get_agent_state(i);
            end
        end
        
        function isOccupied = is_state_occupied(self, state)
            if is_member_optimized_row_one_state_several_states(state, self.get_occupied_states())
                isOccupied = true;
            else
                isOccupied = false;
            end
        end
        
        function freeNeighborStates = get_free_neighbor_states(self, state)
            occupiedStates = self.get_occupied_states();
            neighborStates = self.environment.get_neighbor_states(state);
            freeNeighborStates = setdiff(neighborStates,occupiedStates, 'rows');
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
            if self.is_prey_locked() && ismember(self.get_prey_state(), self.lockingState, 'rows')
                isLocked = true;
            end
        end
        
        %%
        function visibleStates = compute_visible_states(self, startState, visibleAreaActionSequence)
            visibleStates = zeros(size(visibleAreaActionSequence,1),2);
            for i = 1:size(visibleAreaActionSequence,1)
                state = startState;
                for j = 1:size(visibleAreaActionSequence,2)
                    state = self.environment.eval_next_state(state, visibleAreaActionSequence(i,j));
                end
                visibleStates(i,:) = state;
            end
            visibleStates = unique(visibleStates, 'rows');
        end
        
        %         function [nextState, cost] = evaluate_action(self, startState, action, endState)
        %             cost = 1;
        %             nextState = self.environment.eval_next_state(startState, action);
        %             if ~ismember(nextState, endState, 'rows')
        %                 if self.is_state_occupied(nextState)
        %                     nextState = startState;
        %                     cost = 1000;
        %                 end
        %             end
        %         end
        
        %%
        function actionProba = compute_optimal_action_proba(self, initState, targetState)
            [optimalPolicy, MDP]  = self.compute_optimal_policy(targetState);
            initMDPState = MDP.position_to_state(initState);
            actionProba = full(optimalPolicy(initMDPState,:));
        end
        
        function [optimalPolicy, MDP] = compute_optimal_policy(self, targetState)
            MDP = self.environment.generate_toroidal_mdp(self.noiseLevel);
            for i = 1:length(self.agents)
                agentState = self.get_agent_state(i);
                if ~all(agentState == targetState)
                    MDP.add_obstacle_at_position(agentState)
                end
            end
            MDP.set_unitary_sparse_reward_at_position(targetState)
            MDP.build_MDP()
            [~, optimalPolicy] = VI(MDP, self.maxErr);
        end
        
        %% load and save state
        
        function domainState = get_domain_state(self)
            domainState = struct;
            %predators states
            domainState.predatorsStates = zeros(length(self.predatorsIdx), 2);
            for i = self.predatorsIdx
                domainState.predatorsStates(i, :) = self.get_agent_state(i);
            end
            %prey state
            domainState.preyState = self.get_prey_state();
        end
        
        function load_domain_state(self, domainState)
            % loading must be done on the same domain (or a copy) such that
            % agents are in the same ordering
            %load predator state
            for i = self.predatorsIdx
                self.set_agent_state(i, domainState.predatorsStates(i, :));
            end
            %load prey state
            self.set_agent_state(self.preyIdx, domainState.preyState);
        end
        
        function logProbaNextDomainState = compute_log_proba_next_domain_state(self, nextDomainState, agentMessages, ordering)
            logProbaNextDomainState = -Inf;
            %set message
            self.set_messages(agentMessages)
            %simulate agent action given messages
            agentsActionsProba = self.collect_agents_actions_proba();
            noiseActionProba = ToroidalGridMDP.generate_all_actions_proba(self.noiseLevel);
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
                if logProba > -Inf                    
                    domainCopy = copy(self);
                    for j = ordering
                        domainCopy.apply_agent_action(j, actionsIndexes(i, j))
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
            self.environment.drawer.draw()
            hold on
            %draw locking state
            posId = self.environment.drawer.get_id(self.lockingState);
            self.environment.drawer.draw_dot(posId, get_nice_color('b'))
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
            if size(domainState1.predatorsStates,1) ~= size(domainState2.predatorsStates,1)
                areEqual = false;
                return
            end
            for i = 1:length(domainState1.predatorsStates)
                if ~ismember(domainState1.predatorsStates(i, :), domainState2.predatorsStates(i, :), 'rows')
                    areEqual = false;
                    return
                end
            end
            %prey
            if size(domainState1.preyState, 1) ~= size(domainState2.preyState, 1)
                areEqual = false;
                return
            end
            if ~all(domainState1.preyState == domainState2.preyState) % assumes one prey
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




