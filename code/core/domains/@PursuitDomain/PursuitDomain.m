classdef PursuitDomain < handle %matlab.mixin.Copyable
    
    properties
        environment
        agents = {}
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
            self.predatorsIdx(end+1) = id;
            predator.id = id;
        end
        
        function add_prey(self, prey)
            if isempty(self.preyIdx)
                self.agents{end+1} = prey;
                id = length(self.agents);
                self.preyIdx = id;
                prey.id = id;
            else
                warning('You can only have one prey')
            end
        end
        
        %%
        function iterate(self)
            %             self.move_preys()
            %             self.move_predators()
            %             self.move_all_agents_random_ordering()
            %             self.move_all_agents_in_order()
            self.apply_actions_in_order(self.collect_agents_actions())
            if ~self.check_states()
                error('something went wrong states are identical!!!')
            end
        end
        
        %%
        function agentsActions = collect_agents_actions(self, ordering)
            agentsActions = zeros(length(self.agents));
            for i = ordering
                agentsActions(i) = self.agents{i}.select_action();
            end
        end
        
        function apply_agents_actions(self, agentsActions, ordering)
            for i = ordering
                self.apply_agent_action(i, agentsActions(i))
            end
        end
        
        function apply_agent_action(self, agentIdx, action)
            nextState = self.environment.eval_next_state(self.agents{agentIdx}.state, action);
            if ~self.is_state_occupied(nextState)
                self.agents{agentIdx}.state = nextState;
            end
        end
        
        %%
        function ordering = get_random_ordering(self)
            ordering = randperm(length(self.agents));
        end
        
        function ordering = get_random_ordering_among_predators(self)
            ordering = self.predatorsIdx(randperm(length(self.predatorsIdx)));
        end
        
        function preyIdx = get_prey_idx(self)
            preyIdx = self.preyIdx;
        end
        
        %%
        function init(self)
            % assign random states
            for i = 1:length(self.agents)
                self.agents{i}.state = self.environment.get_random_state();
            end
            
            %repeat while init not okay
            if ~self.check_init()
                self.init()
            end
        end
        
        function initValid = check_init(self)
            initValid = false;
            
            if ~check_states(self)
                return
            end
            
            %if it wenty through it is valid
            initValid = true;
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
                occupiedStates(i, :) = self.agents{i}.state;
            end
        end
        
        function isOccupied = is_state_occupied(self, state)
            if ismember(state, self.get_occupied_states(), 'rows')
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
            isLocked = false;
            if ~isempty(self.get_free_neighbor_states(self.agents{self.preyIdx}.state))
                return
            end
            if ~ismember(self.agents{self.preyIdx}.state, self.lockingState, 'rows')
                return
            end
            isLocked = true;
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
                self.agents{i}.draw();
            end
        end
        
        
        %%
        function [nextState, cost] = evaluate_action(self, startState, action)
            cost = 1;
            nextState = self.environment.eval_next_state(startState, action);
            if self.is_state_occupied(nextState)
                nextState = startState;
                cost = 1000;
            end
        end
    end
    
%     methods(Access = protected)
%         % Override copyElement method:
%         function copySelf = copyElement(self)
%             % Make a shallow copy of all four properties
%             copySelf = copyElement@matlab.mixin.Copyable(self);
%             % Make a deep copy of the DeepCp object
%             for i = 1:length(self.agents)
%                 copySelf.agents{i} = copy(self.agents{i});
%             end
%         end
%     end
end
    
    
    
    
