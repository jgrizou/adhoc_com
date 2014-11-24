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
        
        function targetStates = compute_target_states(self, domain)
            preyState = domain.get_prey_state();            
            targetStates = domain.environment.eval_next_state_no_noise(preyState, self.cardinal);
        end
                
    end
end

