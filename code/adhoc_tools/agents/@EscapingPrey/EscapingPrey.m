classdef EscapingPrey < BasicAgent
    
    properties
        
    end
    
    methods
        
        function self = EscapingPrey()
            self@BasicAgent(get_nice_color('g'))
        end
        
        function targetStates = compute_target_states(self, domain)
            agentState = self.get_state(domain);
            freeNeighborStates = domain.get_free_neighbor_states(agentState);
            if ~isempty(freeNeighborStates)
                targetStates = freeNeighborStates;
            else
                targetStates = agentState;
            end
        end
        
        function draw(self, domain)
            agentState = self.get_state(domain);
            agentPosition = domain.environment.state_to_position(agentState);
            domain.environment.drawer.draw_square(agentPosition, [1,1,1], 'prey')
            domain.environment.drawer.draw_dot(agentState, self.color)
        end
        
    end
end

