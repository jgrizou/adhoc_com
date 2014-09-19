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
        
        function draw(self, domain)
            if ~isempty(self.get_state(domain))
                if ~isempty(self.id)
                    domain.environment.drawer.draw_square(self.get_state(domain), [1,1,1], num2str(self.id))
                end
                posId = domain.environment.drawer.get_id(self.get_state(domain));
                domain.environment.drawer.draw_dot(posId, self.color)
            end
        end
        
        function action = compute_action(self, domain)
            actionProba = self.compute_action_proba(domain);
            action = sample_action_discrete_policy(actionProba, 1);
        end
        
        function actionProba = compute_action_proba(self, domain)
            targetState = self.compute_target_state(domain);
            actionProba = self.compute_action_proba_to_reach_target_state(domain, targetState);
        end
        
        function actionProba = compute_action_proba_to_reach_target_state(self, domain, targetState)
            agentState = self.get_state(domain);
            if all(agentState == targetState) % just for the speed up
                actionProba = [0 0 0 0 1]; % don't move
            else
                neighborStates = domain.environment.get_neighbor_states(agentState);
                if is_member_optimized_row_one_state_several_states(targetState, neighborStates) % just for the speed up
                    action = domain.environment.get_action_to_neighbor_state(agentState, targetState);
                    actionProba = zeros(1,5);
                    actionProba(action) = 1;
                else
                    actionProba = domain.compute_optimal_action_proba(self.get_state(domain), targetState);
                end
            end
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

