classdef BasicAgent < matlab.mixin.Copyable
    %@BASICAGENT
    
    properties
        id
        color = get_random_color()
    end
    
    methods
        
        function self = BasicAgent(color)
            if nargin > 0
                self.color = color;
            end
        end
        
        function state = get_state(self, domain)
            state = domain.get_agent_state(self.id);
        end
        
        function action = compute_action(self, domain, recorder)
            actionProba = self.compute_action_proba(domain, recorder);
            action = sample_action_discrete_policy(actionProba, 1); recorder.logit(action)
        end
        
        function actionProba = compute_action_proba(self, domain, recorder)
            agentState = self.get_state(domain);
            stateReward = self.compute_state_reward(domain); recorder.logit(stateReward)
            obstacleProba = self.compute_obstacle_proba(domain, stateReward); recorder.logit(obstacleProba)
            actionProba = domain.compute_optimal_action_proba(agentState, stateReward, obstacleProba); recorder.logit(actionProba)
        end
        
        function stateReward = compute_state_reward(self, domain)
            targetStates = self.compute_target_states(domain);
            stateReward = self.state_reward_from_target_states(domain, targetStates);
        end
        
        function stateReward = state_reward_from_target_states(~, domain, targetStates)
            stateReward = domain.environment.get_empty_state_reward();
            stateReward(targetStates) = 1;
        end
        
        function obstacleProba = compute_obstacle_proba(~, domain, stateReward)
            obstacleProba = domain.environment.get_empty_obstacle_proba();
            occupiedStates = domain.get_occupied_states();
            toFreeState = find(stateReward > 0);
            obstacleState = setdiff(occupiedStates, toFreeState);
            obstacleProba(obstacleState) = 1;
        end
        
        
        
        %%
        function draw(self, domain)
            agentState = self.get_state(domain);
            if ~isempty(self.id)
                agentPosition = domain.environment.state_to_position(agentState);
                domain.environment.drawer.draw_square(agentPosition, [1,1,1], num2str(self.id))
            end
            domain.environment.drawer.draw_dot(agentState, self.color)
        end
        
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function copySelf = copyElement(self)
            % Make a shallow copy of all properties
            copySelf = copyElement@matlab.mixin.Copyable(self);
        end
    end
    
end

