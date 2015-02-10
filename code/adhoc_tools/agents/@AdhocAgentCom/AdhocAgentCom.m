classdef AdhocAgentCom < AdhocAgent
    %ADHOCAGENT
    
    properties
        comType %'absolute' or 'relative'
        comMapping % the maping should be an array mapping 1:nStates to 1:nStates
        comNoiseLevel % uniform noise, the agent may can communicate one state neighbor to the prey        
    end
    
    methods
        
        function self = AdhocAgentCom(domainStructHypothesis)
            self@AdhocAgent(domainStructHypothesis)
        end
        
        %%
        function message = compute_message(self, domain)
            bestHypothesis = sample_action_discrete_policy(self.probaHypothesis, 1);
            hypDomain = create_domain_from_struct(self.domainStructHypothesis{bestHypothesis});
            hypDomain.load_domain_state(domain.get_domain_state());
            message = hypDomain.agents{1}.compute_message(hypDomain);
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
                self.comType = domain.agents{2}.comMapping;
                self.comMapping = domain.agents{2}.comMapping;
                self.comNoiseLevel = domain.agents{2}.comNoiseLevel;

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
        
        function adhocDomain = init_adhoc_com_domain(adhocDomain, domainState, logProbaHypothesis, probaHypothesis)
            adhocDomain.load_domain_state(domainState);
            adhocDomain.agents{1}.logProbaHypothesis = logProbaHypothesis;
            adhocDomain.agents{1}.probaHypothesis = probaHypothesis;
        end
        
        function adhocDomainStruct = create_adhoc_com_domain_struct(domainStructHypothesis, hypothesisSelected)
            adhocDomainStruct = domainStructHypothesis{hypothesisSelected};
            adhocDomainStruct.predators{1} = AdhocAgentCom(domainStructHypothesis);
        end
        
        function adhocDomain = create_adhoc_com_domain(domainStructHypothesis, hypothesisSelected)
            adhocDomainStruct = AdhocAgentCom.create_adhoc_domain_struct(domainStructHypothesis, hypothesisSelected);
            adhocDomain = create_domain_from_struct(adhocDomainStruct); 
        end
        
    end
end

