classdef Path < handle
    
    properties
        
        domain
        
        cost
        availableActions
        
        remainingActions
        
        visitedStates
        selectedActions
        
    end
    
    methods
        
        function self = Path(domain, availableActions, visitedStates, selectedActions, cost)
            self.domain = domain;
            self.availableActions = availableActions;
            self.remainingActions = self.availableActions;
            self.visitedStates = visitedStates;
            if nargin > 3
                self.selectedActions = selectedActions;
            end
            if nargin > 4
                self.cost = cost;
            else
                self.cost = 0;
            end
        end
        
        function newPath = extend_path(self)
            %take one action and remove from the available one
            i = randi(length(self.remainingActions));
            action = self.remainingActions(i);
            self.remainingActions(i) = [];
            
            % take action
            currentState = self.visitedStates(end, :);
            [newState, actionCost] = self.domain.evaluate_action(currentState, action);
            
            % newPath
            newPath = Path(self.domain, self.availableActions, ...
                [self.visitedStates; newState], ...
                [self.selectedActions, action], ...
                self.cost + actionCost);
        end
        
        function isAlive = is_alive(self)
            if isempty(self.remainingActions)
                isAlive = false;
            else
                isAlive = true;
            end
        end
        
    end
    
end

