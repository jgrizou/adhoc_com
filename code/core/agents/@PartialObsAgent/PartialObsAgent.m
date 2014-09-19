classdef PartialObsAgent < AutoCardinalTaskAgent
    
    properties
        
        visibleAreaActionSequence = [1,5;1,1;2,5;2,2;3,5;3,3;4,5;4,4;1,3;2,4;3,2;4,1;5,5]
        
    end
    
    methods
        
        function self = PartialObsAgent(cardinal)
            self@AutoCardinalTaskAgent(cardinal)
        end
        
        %%
        function actionProba = compute_action_proba(self, domain)
            if self.is_prey_visible(domain)
                targetState = self.compute_target_state(domain);
                actionProba = self.compute_action_proba_to_reach_target_state(domain, targetState);
            else % move at random
                actionProba = proba_normalize_row(ones(1,domain.environment.nActions));
            end            
        end        
        
        %%
        function isVisible = is_prey_visible(self, domain)
            isVisible = false;
            visibleStates = self.get_visible_states(domain);
            if ismember(domain.get_prey_state(), visibleStates, 'rows')
                isVisible = true;
            end
        end
        
        function visibleStates = get_visible_states(self, domain)
            visibleStates = domain.compute_visible_states(self.get_state(domain), self.visibleAreaActionSequence);
        end
            
        %%
        function draw_visible_states(self, domain)
            domain.environment.drawer.draw()
            visibleStates = self.get_visible_states(domain);
            for i = 1:size(visibleStates,1)
                domain.environment.drawer.draw_square(visibleStates(i,:), 'y')
            end
        end        
    end
end

