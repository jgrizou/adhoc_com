classdef EscapingPrey < BasicAgent
    
    properties
        
    end
    
    methods
        
        function self = EscapingPrey()
            self@BasicAgent(get_nice_color('g'))
        end
        
        function actionProba = compute_action_proba(self, domain)
            validActions = zeros(1,domain.environment.nActions);
            
            freeNeighborStates = domain.get_free_neighbor_states(self.get_state(domain));
            if size(freeNeighborStates,1) > 0
                for i = 1:size(freeNeighborStates,1)
                    nextState = freeNeighborStates(i,:);
                    action = domain.environment.get_action_to_neighbor_state(self.get_state(domain), nextState);
                    validActions(action) = 1;
                end
            else
                validActions(5) = 1;
            end           
            
            actionProba = proba_normalize_row(validActions);
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

