classdef PartialObsAgent < AutoCardinalTaskAgent
    
    properties
        
        visibleAreaActionSequence = [1,5;1,1;2,5;2,2;3,5;3,3;4,5;4,4;1,3;2,4;3,2;4,1;5,5]
        
    end
    
    methods
        
        function self = PartialObsAgent(cardinal)
            self@AutoCardinalTaskAgent(cardinal)
        end
        
        %%
        
        function actionProba = compute_action_proba(self, domain, recorder)
            agentState = self.get_state(domain);
            preyStateProba = self.compute_prey_state_proba(domain); recorder.logit(preyStateProba)
            stateReward = self.compute_state_reward(domain, preyStateProba); recorder.logit(stateReward)
            obstacleProba = self.compute_obstacle_proba(domain, stateReward, preyStateProba); recorder.logit(obstacleProba)
            actionProba = domain.compute_optimal_action_proba(agentState, stateReward, obstacleProba); recorder.logit(actionProba)
        end
        
        function preyStateProba = compute_prey_state_proba(self, domain)
            
            preyStateProba = domain.environment.get_empty_obstacle_proba(); % same size
                
            if self.is_prey_visible(domain)
                preyState = domain.get_prey_state();
                preyStateProba(preyState) = 1;
            else
                preyStates = self.get_invisible_states(domain);
                preyStateProba(preyStates) = 1/length(preyStates);
            end
            
            if ~is_proba_normalized_row(preyStateProba)
                error('preyStateProba non normalized')
            end
        end
        
        function stateReward = compute_state_reward(self, domain, preyStateProba)
            stateReward = domain.environment.get_empty_state_reward();
            for i = 1:length(preyStateProba)
                if preyStateProba(i) > 0
                    targetState = self.compute_target_states_from_prey_states(domain, i);
                    stateReward(targetState) = preyStateProba(i);
                end
            end
        end
        
        function obstacleProba = compute_obstacle_proba(~, domain, stateReward, preyStateProba)
            obstacleProba = preyStateProba;
            
            predatorsStates = domain.get_predators_states();
            toFreeState = find(stateReward > 0);
            obstacleState = setdiff(predatorsStates, toFreeState);
            
            obstacleProba(obstacleState) = 1;
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
        
        
        %%
        
        function draw_visible_states(self, domain)
            domain.environment.drawer.reset_colors()
            domain.environment.drawer.draw()
            visibleStates = self.get_visible_states(domain);
            for i = 1:length(visibleStates)
                visiblePosition = domain.environment.state_to_position(visibleStates(i));
                domain.environment.drawer.draw_square(visiblePosition, 'y')
            end
        end
        
        function draw_invisible_states(self, domain)
            domain.environment.drawer.reset_colors()
            domain.environment.drawer.draw()
            visibleStates = self.get_invisible_states(domain);
            for i = 1:length(visibleStates)
                visiblePosition = domain.environment.state_to_position(visibleStates(i));
                domain.environment.drawer.draw_square(visiblePosition, 'y')
            end
        end
    end
end

