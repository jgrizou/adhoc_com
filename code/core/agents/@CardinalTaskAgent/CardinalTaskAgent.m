classdef CardinalTaskAgent < BasicAgent
    %CARDINALTASKAGENT
    
    properties
        
        cardinal % can be 1,2,3,4 for +x, -x, +y, -y
        stucker
        
    end
    
    methods
        
        function self = CardinalTaskAgent(domain, cardinal, stucker)
            self@BasicAgent(domain, get_nice_color('r'))  
            self.cardinal = cardinal;
            self.stucker = stucker;
        end
        
        function action = select_action(self)
            %assume there is only one prey
            preyState = self.domain.agents{self.domain.get_prey_idx()}.state;
            
            targetState = self.domain.environment.eval_next_state(preyState, self.cardinal);
            if ~self.stucker
                if self.cardinal == 1
                    if preyState(1) ~= self.domain.lockingState(1)
                        targetState(1) = targetState(1) + 1;
                    end
                elseif self.cardinal == 2
                    if preyState(1) ~= self.domain.lockingState(1)
                        targetState(1) = targetState(1) - 1;
                    end
                elseif self.cardinal == 3
                    if preyState(2) ~= self.domain.lockingState(2)
                        targetState(2) = targetState(2) + 1;
                    end
                elseif self.cardinal == 4
                    if preyState(2) ~= self.domain.lockingState(2)
                        targetState(2) = targetState(2) - 1;
                    end
                end
                targetState = self.domain.environment.format_state(targetState);
            end
            
            if ismember(self.state, targetState, 'rows')
                action = 5;
                %action = self.domain.environment.get_action_to_neighbor_state(self.state, preyState);
            else
                while self.domain.is_state_occupied(targetState)
                    % WARNING only guarantee to work if no more agent than gridSize!!!
                    targetState = self.domain.environment.eval_next_state(targetState, self.cardinal);
                end
                aStart = AStarSolver(self.domain);
                action = aStart.solve_next_action(self.state, targetState);
            end
        end
        
    end
end

