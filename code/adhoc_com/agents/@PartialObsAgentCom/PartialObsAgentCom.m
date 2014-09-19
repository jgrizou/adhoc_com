classdef PartialObsAgentCom < PartialObsAgent
    
    properties
        comType %'absolute' or 'relative'
    end
    
    methods
        
        function self = PartialObsAgentCom(cardinal,comType)
            self@PartialObsAgent(cardinal)
            self.comType = comType;
        end
        
        %%
        function actionProba = compute_action_proba(self, domain)
            decodedPreyState = PartialObsAgentCom.decode_agent_messages(domain);
            actionProba = self.compute_action_proba_given_prey_state(domain, decodedPreyState);
        end
        
        function actionProba = compute_action_proba_given_prey_state(self, domain, decodedPreyState)
            if self.is_prey_visible(domain)
                targetState = self.compute_target_state(domain);
                actionProba = self.compute_action_proba_to_reach_target_state(domain, targetState);
            elseif ~isempty(decodedPreyState) % if com is known it is the same as above
                targetState = compute_target_state_given_prey_state(self, domain, decodedPreyState);
                actionProba = self.compute_action_proba_to_reach_target_state(domain, targetState);
            else % move at random
                actionProba = proba_normalize_row(ones(1,domain.environment.nActions));
            end
        end
        
        %%
        function message = compute_message(self, domain)
            message = [];
            switch self.comType
                case 'absolute'
                    if self.is_prey_visible(domain)
                        message = domain.get_prey_state();
                    end
                case 'relative'
                    if self.is_prey_visible(domain)
                        message = domain.environment.absolute_to_relative(self.get_state(domain),domain.get_prey_state());
                    end
                otherwise
                    error('comType %s unknown', self.comType)
                    
            end
        end
    end
    
    methods(Static)
        
        function decodedPreyState = decode_agent_messages(domain)
            decodedPreyStates = [];
            %apply action in order if message sent
            for i = domain.predatorsIdx % the ordering does not matter, the prey is not suppose to have send any message
                agent = domain.agents{i};
                message = domain.agentsMessages{i};
                if ~isempty(message)
                    decodedPreyStates(end+1,:) = PartialObsAgentCom.decode_message(domain, agent, message);
                end
            end
            % consider the majority of the votes
            if isempty(decodedPreyStates)
                decodedPreyState = [];
            else
                [decodedPreyStates,k,l] = unique(decodedPreyStates, 'rows');
                if size(decodedPreyStates,1) == 1
                    decodedPreyState = decodedPreyStates;
                else
                    % most vote wins
                    cnt = zeros(size(k));
                    for i = 1:length(k)
                        cnt(i) = length(find(l == k(i)));
                    end
                    idx = randsample(find(cnt == max(cnt)), 1);
                    decodedPreyState = decodedPreyStates(idx,:);
%                     warning('non unique decoded prey State: should never happen yet')
                end
            end
        end
        
        function preyState = decode_message(domain, agent, message)
            switch agent.comType
                case 'absolute'
                    preyState = message;
                case 'relative'
                    preyState = domain.environment.relative_to_absolute(agent.get_state(domain), message);
                otherwise
                    error('comType %s unknown', agent.comType)
            end
        end
    end
end

