classdef PartialObsAgentCom < PartialObsAgent
    
    properties
        comType %'absolute' or 'relative'
        comMapping % the maping should be an array mapping 1:nStates to 1:nStates
        comNoiseLevel % uniform noise, the agent may can communicate one state neighbor to the prey
    end
    
    methods
        
        function self = PartialObsAgentCom(cardinal,comType,comMapping,comNoiseLevel)
            self@PartialObsAgent(cardinal)
            self.comType = comType;
            self.comMapping = comMapping;
            self.comNoiseLevel = comNoiseLevel;
        end
        
        %%
        function preyStateProba = compute_prey_state_proba(self, domain)
            
            if self.is_prey_visible(domain) % only rely on itsobservation of the prey position
                preyStateProba = domain.environment.get_empty_obstacle_proba(); % same size
                preyState = domain.get_prey_state();
                preyStateProba(preyState) = 1;
            else
                % this function could be precomputed to win time, as it is common to all agent
                preyStateProba = PartialObsAgentCom.decode_all_agent_messages(domain); 
            end
            
            if ~is_proba_normalized_row(preyStateProba)
                error('preyStateProba non normalized')
            end
        end
        
        %%
        function availableMessages = get_available_messages(self, domain)
            % messages available to the agent
            availableMessages = domain.agentsMessages;
            if availableMessages(self.id) ~= 0
                error('that shoule never happen for now')
                availableMessages(self.id) = 0; % if you sent a message, remove it from the list
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
            messageProba = zeros(1, length(self.comMapping));
            if self.is_prey_visible(domain) % if see the prey send message
                message = PartialObsAgentCom.encode_message(domain, self, domain.get_prey_state());
                messageProba(message) = 1;
                messageProba = PartialObsAgentCom.forward_noise_message(domain, messageProba, self.comNoiseLevel);
                messageProba = PartialObsAgentCom.map_message_proba(messageProba, self.comMapping);
            end
        end
        
        %%
        function preyStateProba = decode_my_message(self, domain, message)
            preyStateProba = domain.environment.get_empty_obstacle_proba();
          
            % just the fact of talking or not gives a lot of information
            if message == 0 % the agent do not see the prey
                possiblePreyStates = self.get_invisible_states(domain);
            else % the agent see the prey
                possiblePreyStates = self.get_visible_states(domain);
            end
            preyStateProba(possiblePreyStates) = 1/length(possiblePreyStates);
            
            % decode the message if any
            if message ~= 0
                decodedMessageProba = domain.environment.get_empty_obstacle_proba();
                rawMessage = PartialObsAgentCom.unmap_message(message, self.comMapping);
                decodedPreyState = PartialObsAgentCom.decode_message(domain, self, rawMessage);
                decodedMessageProba(decodedPreyState) = 1;
                noisyDecodedMessageProba = PartialObsAgentCom.backward_noise_message(domain, decodedMessageProba, self.comNoiseLevel);
                preyStateProba = preyStateProba .* noisyDecodedMessageProba;
            end
            preyStateProba = proba_normalize_row(preyStateProba);
        end
        
    end
    
    methods(Static)
        
        %%
        function [preyStateProba, allPreyStateProba] = decode_all_agent_messages(domain)            
            allPreyStateProba = ones(length(domain.agents), domain.environment.nStates) / domain.environment.nStates;
            for i = 1:length(domain.agents) % only consider the predators
                agent = domain.agents{i};                
                if ismethod(agent, 'decode_my_message')
                    message = domain.agentsMessages(i);
                    allPreyStateProba(i, :) = agent.decode_my_message(domain, message);
                end
            end
            preyStateLikelihood = prod(allPreyStateProba, 1);
            preyStateProba = proba_normalize_row(preyStateLikelihood);
        end
        
        %%
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
        
        function message = encode_message(domain, agent, preyState)
            switch agent.comType
                case 'absolute'
                    message = preyState;
                case 'relative'
                    message = domain.environment.absolute_to_relative_state(agent.get_state(domain), preyState);
                otherwise
                    error('comType %s unknown', self.comType)
            end
        end
        
        %% applying noise to raw messages
        function noisyRawMessageProba = forward_noise_message(domain, rawMessageProba, comNoiseLevel)
            noisyRawMessageProba = rawMessageProba;
            if comNoiseLevel > 0
                for i = 1:length(rawMessageProba)
                    if rawMessageProba(i) > 0
                        % the smae message is emmited (1-comNoiseLevel) of the time
                        noisyRawMessageProba(i) = (1-comNoiseLevel) * rawMessageProba(i);
                        % neighbor states message are emmited uniformly with the remaining proba
                        neighborStates = domain.environment.get_neighbor_states(i);
                        for j = 1:length(neighborStates)
                            noisyRawMessageProba(neighborStates(j)) = comNoiseLevel/length(neighborStates);
                        end
                    end
                end
            end
        end
        
        function noisyDecodedMessageProba = backward_noise_message(domain, decodedMessageProba, comNoiseLevel)
            % !! WARNING !!
            % this is only possible because the function forward and backward are symetric in our case
            % you shoull rewrite this function if you change the forward noise model!
            noisyDecodedMessageProba = PartialObsAgentCom.forward_noise_message(domain, decodedMessageProba, comNoiseLevel);
        end
        
        %%
        function mappedMessageProba = map_message_proba(rawMessageProba, mapping)
            mappedMessageProba = zeros(size(rawMessageProba));
            for i = 1:length(rawMessageProba)
                mappedMessage = PartialObsAgentCom.map_message(i, mapping);
                mappedMessageProba(mappedMessage) = rawMessageProba(i);
            end
        end
        
        function rawMessageProba = unmap_message_proba(mappedMessageProba, mapping)
            rawMessageProba = zeros(size(mappedMessageProba));
            for i = 1:length(rawMessageProba)
                rawMessage = PartialObsAgentCom.unmap_message(i, mapping);
                rawMessageProba(rawMessage) = mappedMessageProba(i);
            end
        end
        
        %%
        function mappedMessage = map_message(rawMessage, mapping)
            mappedMessage = mapping(rawMessage);
        end
        
        function rawMessage = unmap_message(mappedMessage, mapping)
            rawMessage = find(mapping == mappedMessage);
        end
        
        %%
        function draw_prey_state_proba(domain, preyStateProba)
            limMinMax = [0, 1];
            domain.environment.drawer.set_all_colors_by_values(preyStateProba, limMinMax)
            domain.environment.drawer.draw(limMinMax)
        end
        
    end
end

