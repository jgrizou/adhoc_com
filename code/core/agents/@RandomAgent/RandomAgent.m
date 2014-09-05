classdef RandomAgent < BasicAgent
    
    properties
    end
    
    methods
        
        function self = RandomAgent(domain, color)
            if nargin < 2
                color = get_random_color;
            end
            self@BasicAgent(domain, color)           
        end
        
        function action = select_action(self)
            action = randi(self.domain.environment.nActions);
        end
    end    
end

