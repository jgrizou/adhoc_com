classdef EscapingPrey < BasicAgent
    
    properties
    end
    
    methods
        
        function self = EscapingPrey(domain)
            self@BasicAgent(domain, get_nice_color('g'))
        end
        
        function action = select_action(self)
            freeNeighborStates = self.domain.get_free_neighbor_states(self.state);
            if size(freeNeighborStates,1) > 0
                nextState = freeNeighborStates(randi(size(freeNeighborStates,1)),:);
                action = self.domain.environment.get_action_to_neighbor_state(self.state, nextState);
            else
                action = 5;
            end
        end       
        
        function draw(self)
            if ~isempty(self.state)
                self.domain.environment.drawer.draw_square(self.state, [1,1,1], 'prey')
                posId = self.domain.environment.drawer.get_id(self.state);
                self.domain.environment.drawer.draw_dot(posId, self.color)
            end
        end
        
    end    
end

