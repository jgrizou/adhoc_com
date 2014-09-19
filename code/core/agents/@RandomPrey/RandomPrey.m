classdef RandomPrey < RandomAgent
    
    properties
    end
    
    methods
        
        function self = RandomPrey()
            self@RandomAgent(get_nice_color('g'))           
        end        
                
        function draw(self, domain)
            if ~isempty(self.get_state(domain))
                domain.environment.drawer.draw_square(self.get_state(domain), [1,1,1], 'prey')
                posId = domain.environment.drawer.get_id(self.get_state(domain));
                domain.environment.drawer.draw_dot(posId, self.color)
            end
        end
        
    end    
end

