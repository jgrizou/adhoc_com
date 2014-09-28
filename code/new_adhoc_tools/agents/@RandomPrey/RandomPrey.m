classdef RandomPrey < RandomAgent
    
    properties
    end
    
    methods
        
        function self = RandomPrey()
            self@RandomAgent(get_nice_color('g'))
        end
        
        function draw(self, domain)
            agentState = self.get_state(domain);
            agentPosition = domain.environment.state_to_position(agentState);
            domain.environment.drawer.draw_square(agentPosition, [1,1,1], 'prey')
            domain.environment.drawer.draw_dot(agentState, self.color)
        end
        
    end
end

