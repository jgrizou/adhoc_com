classdef CardinalTaskAgentCom < CardinalTaskAgent
    %CARDINALTASKAGENTCOM
    
    properties
                
        comType % can be 'action' or 'cardinal'
        comMapping
               
    end
    
    methods
        
        function self = CardinalTaskAgentCom(cardinal, stucker, comType, comMapping)
            self@CardinalTaskAgent(cardinal, stucker)            
            self.comMapping = comMapping;
            self.comType = comType;
        end
        
        %%
        function [action, message] = collect_action_and_message(self, domain, agentsMessages) %may be usefull to had the ordering, not needed if agents work well
            domainUpdated = CardinalTaskAgentCom.update_domain_with_com(domain, agentsMessages);
            action = self.compute_action(domainUpdated);
            message = compute_message(self, action);
        end
                
        %%        
        function message = compute_message(self, action)
            message = [];
            switch self.comType
                case 'action'
                    if action < 5
                        message = self.comMapping(action);
                    end
                case 'cardinal'
                    message = self.comMapping(self.cardinal);                    
                otherwise
                    error('comType %s unknown', self.comType)
                    
            end
        end        
    end
    
    methods(Static)
        
        function domainUpdated = update_domain_with_com(domain, agentsMessages)
            %copy domain
            domainUpdated = copy(domain);
            ordering = domainUpdated.get_current_ordering();
            %apply action in order is message sent
            for i = ordering
                agent = domainUpdated.agents{i};
                message = agentsMessages{i};
                if ~isempty(message)                    
                    action = CardinalTaskAgentCom.decode_message(domainUpdated, agent, message);
                    domainUpdated.apply_agent_action(i, action)
                end
            end
        end
        
        function action = decode_message(domain, agent, message)
            switch agent.comType
                case 'action'
                    action = find(message == agent.comMapping);
                case 'cardinal'
                    decodedCardinal = find(message == agent.comMapping);
                    if agent.cardinal ~= decodedCardinal
                        error('something wrong in decoding message')
                    end                    
                    action = agent.compute_action(domain);
                otherwise
                    error('comType %s unknown', agent.comType)                    
            end
        end
        
    end
end


