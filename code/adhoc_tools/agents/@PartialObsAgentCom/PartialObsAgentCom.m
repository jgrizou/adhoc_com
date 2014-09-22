classdef PartialObsAgentCom < PartialObsAgent
    
    properties
        comType %'absolute' or 'relative'
        comMapping % the maping should be an array mapping 1:nStates to 1:nStates
        comNoiseLevel % unifrom noise on the message, can communicate one state neighbor to the prey
    end
    
    methods
        
        function self = PartialObsAgentCom(cardinal,comType,comMapping,comNoiseLevel)
            self@PartialObsAgent(cardinal)
            self.comType = comType;
            self.comMapping = comMapping;
            self.comNoiseLevel = comNoiseLevel;
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
            messageProba = self.compute_message_proba(domain);
            if nnz(messageProba) == 0
                message = [];
            else
                message = sample_action_discrete_policy(messageProba, 1);
            end
        end
        
        function messageProba = compute_message_proba(self, domain)
            messageProba = zeros(1, length(self.comMapping));
            position = [];
            switch self.comType
                case 'absolute'
                    if self.is_prey_visible(domain)
                        position = domain.get_prey_state();
                    end
                case 'relative'
                    if self.is_prey_visible(domain)
                        position = domain.environment.absolute_to_relative(self.get_state(domain),domain.get_prey_state());
                    end
                otherwise
                    error('comType %s unknown', self.comType)
            end
            if ~isempty(position)
                % the true state message                
                message = ToroidalGridMDP.position_to_state(domain.environment.gridSize, position);
                message = PartialObsAgentCom.map_message(message, self.comMapping);
                messageProba(message) = 1-self.comNoiseLevel;
                % the noisy one
                if self.comNoiseLevel > 0
                    neighborStates = domain.environment.get_neighbor_states(position);
                    for i = 1:size(neighborStates, 1)
                        message = ToroidalGridMDP.position_to_state(domain.environment.gridSize, neighborStates(i,:));           
                        message = PartialObsAgentCom.map_message(message, self.comMapping);
                        messageProba(message) = self.comNoiseLevel/size(neighborStates, 1);
                    end
                end
            end
        end
    end
    
    methods(Static)
        
        function decodedPreyState = decode_agent_messages(domain)
            decodedPreyStatesFromMessages = [];
            %apply action in order if message sent
            for i = domain.predatorsIdx % the ordering does not matter, the prey is not suppose to have send any message
                agent = domain.agents{i};
                message = domain.agentsMessages{i};
                if ~isempty(message)
                    unmappedMessage = PartialObsAgentCom.unmap_message(message, agent.comMapping);
                    decodedPreyStatesFromMessages(end+1,:) = PartialObsAgentCom.decode_message(domain, agent, unmappedMessage);
                end
            end
            % consider the majority of the votes
            if isempty(decodedPreyStatesFromMessages)
                decodedPreyState = [];
            else
                [decodedPreyStatesFromMessages,k,l] = unique(decodedPreyStatesFromMessages, 'rows');
                if size(decodedPreyStatesFromMessages,1) == 1
                    decodedPreyState = decodedPreyStatesFromMessages;
                else
                    warning('non unique decoded prey State: should never happen yet')
                    % most vote wins
                    cnt = zeros(size(k));
                    for i = 1:length(k)
                        cnt(i) = length(find(l == k(i)));
                    end
                    idx = randsample(find(cnt == max(cnt)), 1);
                    decodedPreyState = decodedPreyStatesFromMessages(idx,:);
                end
            end
        end
        
        function preyState = decode_message(domain, agent, message)
            decodedPosition= ToroidalGridMDP.state_to_position(domain.environment.gridSize, message);
            switch agent.comType
                case 'absolute'
                    preyState = decodedPosition;
                case 'relative'
                    preyState = domain.environment.relative_to_absolute(agent.get_state(domain), decodedPosition);
                otherwise
                    error('comType %s unknown', agent.comType)
            end
        end
        
        function mappedMessage = map_message(rawMessage, mapping)
            mappedMessage = mapping(rawMessage);
        end
        
        function rawMessage = unmap_message(mappedMessage, mapping)
            rawMessage = find(mapping == mappedMessage);
        end
        
    end
end

