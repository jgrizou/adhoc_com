classdef CardinalAgent < BasicAgent
    %CARDINALAGENT
    
    properties
        cardinal % can be 1,2,3,4 for +x, -x, +y, -y
    end
    
    methods
        
        function self = CardinalAgent(domain, cardinal)
            self@BasicAgent(domain, get_nice_color('r'))            
            self.cardinal = cardinal;
        end
        
        function action = select_action(self)
            %assume there is only one prey
            preyState = self.domain.agents{self.domain.preysIdx(1)}.state;
            
            sideStateTaken = self.domain.environment.eval_next_state(preyState, self.cardinal);
            if ismember(self.state, sideStateTaken, 'rows')
                action = 5;
            else
                if self.domain.is_state_occupied(sideStateTaken)
                    %if occupied move randomly
                    action = randi(self.domain.environment.nActions);
                else
                    % do AStart
                    aStart = AStarSolver(self.domain);
                    action = aStart.solve_next_action(self.state, sideStateTaken);
                end
            end
        end
        
    end
end

