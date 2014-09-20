classdef ToroidalGrid < handle
    
    properties
        
        gridSize
        
        nStates
        nActions = 5
        
        % states are expressed as [x,y] coordinate in integer
        % actions can be 1,2,3,4,5 for +x, -x, +y, -y, nop
        actionEffects = [1,0;
            -1,0;
            0,1;
            0,-1;
            0,0]
        
        drawer
        
    end
    
    methods
        
        function self = ToroidalGrid(gridSize)            
            self.gridSize = gridSize;
            self.nStates = self.gridSize.^2;            
            self.drawer = Squares_plot(self.list_all_states());
        end
        
        %%
        function state = format_state(self, state)
            state = mod(state - [1,1], self.gridSize) + [1,1];
        end
                
        %%
        function nextState = eval_next_state(self, startState, action)
            if action > 0 && action <= self.nActions
                nextState = startState + self.actionEffects(action,:);
                nextState = self.format_state(nextState);
            else
                error('action not valid. given %d, should be integer between 1 and %d', action, self.nActions)
            end
        end
        
        %%
        function randomState = get_random_state(self)
            randomState = randi(self.gridSize,1,2);
        end
        
        function allStates = list_all_states(self)
            [x,y]=meshgrid(1:self.gridSize,1:self.gridSize);
            allStates = [reshape(x, self.nStates, 1), reshape(y, self.nStates, 1)];
        end
        
        function neighborStates = get_neighbor_states(self, state)
            neighborStates = zeros(4,2);
            for action = 1:4
                neighborStates(action, :) = self.eval_next_state(state, action);
            end
        end
        
        function areNeighbor = are_states_neighbor(self, state1, state2)
            neighborStates = self.get_neighbor_states(state1);
            areNeighbor = ismember(state2, neighborStates, 'rows');
        end
        
        %%
        function action = get_action_id(self, actionEffect)
            [~, ~, action] = intersect(actionEffect, self.actionEffects, 'rows');
        end
        
        function action = get_action_to_neighbor_state(self, startState, endState)
            % only work because of the way the get_neighbor_states is made
            neighborStates = get_neighbor_states(self, startState);
            [~, action, ~] = intersect(neighborStates, endState, 'rows');
            if isempty(action)
                error('states are not neighbors')
            end
        end
        
        %%
        function manhattanDistances = distance_between_state(self, initState, goalStates)
            manhattanDistances = zeros(size(goalStates,1), 1);
            for i = 1:size(goalStates, 1)
                [dx, ~] = self.delta_x(initState, goalStates(i,:));
                [dy, ~] = self.delta_y(initState, goalStates(i,:));
                manhattanDistances(i) = dx + dy;
            end
        end
        
        function [dx, direction] = delta_x(self, initState, goalState)
            dx = goalState(1) - initState(1);
            direction = sign(dx);
            dx = abs(dx);
            if dx > self.gridSize/2
                dx = self.gridSize - dx;
                direction = -direction;
            end
        end
        
        function [dy, direction] = delta_y(self, initState, goalState)
            dy = goalState(2) - initState(2);
            direction = sign(dy);
            dy = abs(dy);
            if dy > self.gridSize/2
                dy = self.gridSize - dy;
                direction = -direction;
            end
        end
        
        %% Warning these function are made such that [1,1] in relative is the reference!!
        function absoluteState = relative_to_absolute(self, referenceState, relativeState)
            absoluteState = self.format_state(referenceState + relativeState - [1,1]);
        end
        
        function relativeState = absolute_to_relative(self, referenceState, absoluteState)
            relativeState = self.format_state(absoluteState - referenceState + [1,1]);
        end
        
        %%        
        function MDP = generate_toroidal_mdp(self, noiseLevel)
            MDP = ToroidalGridMDP(self.gridSize,noiseLevel);
        end
                       
    end
end

