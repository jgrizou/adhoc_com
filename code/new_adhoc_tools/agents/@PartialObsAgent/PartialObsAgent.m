classdef PartialObsAgent < AutoCardinalTaskAgent
    
    properties
        
        visibleAreaActionSequence = [1,5;1,1;2,5;2,2;3,5;3,3;4,5;4,4;1,3;2,4;3,2;4,1;5,5]
        
    end
    
    methods
        
        function self = PartialObsAgent(cardinal)
            self@AutoCardinalTaskAgent(cardinal)
        end
        
        %%
        function visibleStates = get_visible_states(self, domain)
            visibleStates = domain.compute_visible_states(self.get_state(domain), self.visibleAreaActionSequence);
        end
        
        function invisibleStates = get_invisible_states(self, domain)
            visibleStates = self.get_visible_states(domain);
            invisibleStates = setdiff(1:domain.environment.nStates, visibleStates);
        end
        
        function isVisible = is_prey_visible(self, domain)
            isVisible = false;
            visibleStates = self.get_visible_states(domain);
            if any(domain.get_prey_state() == visibleStates)
                isVisible = true;
            end
        end
        
        function stateReward = compute_state_reward(self, domain)
            stateReward = domain.environment.get_empty_state_reward();
            if self.is_prey_visible(domain)
                preyStates = domain.get_prey_state();          
            else
                preyStates = self.get_invisible_states(domain);
            end            
            targetStates = self.compute_target_states_from_prey_states(domain, preyStates);
            stateReward(targetStates) = 1; % all equiprobable
        end
               
        function obstacleProba = compute_obstacle_proba(~, domain, stateReward)
            obstacleProba = domain.environment.get_empty_obstacle_proba();
            occupiedStates = domain.get_occupied_states();
            toFreeState = find(stateReward > 0);
            obstacleState = setdiff(occupiedStates, toFreeState);
            obstacleProba(obstacleState) = 1;
        end
        
        %%
        
        function draw_visible_states(self, domain)
            domain.environment.drawer.draw()
            visibleStates = self.get_visible_states(domain);
            for i = 1:length(visibleStates)
                visiblePosition = domain.environment.state_to_position(visibleStates(i));
                domain.environment.drawer.draw_square(visiblePosition, 'y')
            end
        end
        
        function draw_invisible_states(self, domain)
            domain.environment.drawer.draw()
            visibleStates = self.get_invisible_states(domain);
            for i = 1:length(visibleStates)
                visiblePosition = domain.environment.state_to_position(visibleStates(i));
                domain.environment.drawer.draw_square(visiblePosition, 'y')
            end
        end
    end
end

