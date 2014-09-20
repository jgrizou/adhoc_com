classdef CardinalAgent < BasicAgent
    %CARDINALAGENT
    
    properties
        cardinal % can be 1,2,3,4 for +x, -x, +y, -y
    end
    
    methods
        
        function self = CardinalAgent(cardinal)
            self@BasicAgent(get_nice_color('r'))
            self.cardinal = cardinal;
        end
        
        function targetState = compute_target_state(self, domain)
            preyState = domain.get_prey_state();            
            targetState = domain.environment.eval_next_state(preyState, self.cardinal);
        end
                
    end
end

