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
            agentState = self.get_state(domain);
            preyStateProba = self.compute_prey_state_proba(domain);
            stateReward = self.compute_state_reward(domain, preyStateProba);
            obstacleProba = self.compute_obstacle_proba(domain, stateReward, preyStateProba);
            actionProba = domain.compute_optimal_action_proba(agentState, stateReward, obstacleProba);
        end
        
        function preyStateProba = compute_prey_state_proba(self, domain)
            
            preyStateProba = domain.environment.get_empty_obstacle_proba; % same size
            
            if self.is_prey_visible(domain)
                preyState = domain.get_prey_state()
                preyStateProba(preyState) = 1;
            elseif self.are_messages_available(domain) % look at messages
                decodedPreyState = PartialObsAgentCom.decode_agent_messages(domain) % this decodieng function should be rewritten from scratch
                preyStateProba(decodedPreyState) = 1;
            else
                preyStates = self.get_invisible_states(domain)
                preyStateProba(preyStates) = 1/length(preyStates);
            end
            
            if ~is_proba_normalized_row(preyStateProba)
               error('preyStateProba non normalized') 
            end
        end
        
        function stateReward = compute_state_reward(self, domain, preyStateProba)
            allStates = domain.environment.get_all_states();
            targetStates = self.compute_target_states_from_prey_states(domain, allStates);
            
            stateReward = domain.environment.get_empty_state_reward();
            for i = 1:length(preyStateProba)
                stateReward(targetStates(i)) = preyStateProba(i); % all equiprobable
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
        function messagesAvailable = are_messages_available(~, domain)
            if nnz(domain.agentsMessages) > 0
                messagesAvailable = true;
            else
                messagesAvailable = false;
            end
        end
        
        
        %%
        function message = compute_message(self, domain)
            messageProba = self.compute_message_proba(domain);
            if nnz(messageProba) == 0
                message = 0; % a message of zero means no message
            else
                message = sample_action_discrete_policy(messageProba, 1);
            end
        end
        
        function messageProba = compute_message_proba(self, domain)
            preyState = [];
            switch self.comType
                case 'absolute'
                    if self.is_prey_visible(domain)
                        preyState = domain.get_prey_state();
                    end
                case 'relative'
                    if self.is_prey_visible(domain)
                        preyState = domain.environment.absolute_to_relative_state(self.get_state(domain),domain.get_prey_state());
                    end
                otherwise
                    error('comType %s unknown', self.comType)
            end
            messageProba = zeros(1, length(self.comMapping));
            if ~isempty(preyState)
                % the true state message
                message = PartialObsAgentCom.map_message(preyState, self.comMapping);
                messageProba(message) = 1-self.comNoiseLevel;
                % the noisy one
                if self.comNoiseLevel > 0
                    neighborStates = domain.environment.get_neighbor_states(preyState);
                    for i = 1:size(neighborStates, 1)
                        message = PartialObsAgentCom.map_message(neighborStates(i), self.comMapping);
                        messageProba(message) = self.comNoiseLevel/size(neighborStates, 1);
                    end
                end
            end
        end
        
    end
    
    methods(Static)
        
        %% all this need to be redone from scratch
        function decodedPreyState = decode_agent_messages(domain)
            decodedPreyStatesFromMessages = [];
            %apply action in order if message sent
            for i = 1:length(domain.predatorsIdx) % the ordering does not matter, the prey is not suppose to have send any message
                agentIdx = domain.predatorsIdx(i)
                agent = domain.agents{agentIdx};
                message = domain.agentsMessages(agentIdx)
                if message ~= 0
                    unmappedMessage = PartialObsAgentCom.unmap_message(message, agent.comMapping);
                    decodedPreyStatesFromMessages(end+1,:) = PartialObsAgentCom.decode_message(domain, agent, unmappedMessage);
                end
            end
            % consider the majority of the votes
            if isempty(decodedPreyStatesFromMessages)
                decodedPreyState = [];
            else
                [decodedPreyStatesFromMessages,k,l] = unique(decodedPreyStatesFromMessages);
                if size(decodedPreyStatesFromMessages,1) == 1
                    decodedPreyState = decodedPreyStatesFromMessages;
                else
                    % warning('non unique decoded prey State: should never happen yet')
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
            switch agent.comType
                case 'absolute'
                    preyState = message;
                case 'relative'
                    preyState = domain.environment.relative_to_absolute_state(agent.get_state(domain), message);
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

