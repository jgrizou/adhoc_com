classdef PartialObsAgentMute < PartialObsAgent
    
    properties
        comType %'absolute' or 'relative'
        comMapping % the maping should be an array mapping 1:nStates to 1:nStates
        comNoiseLevel % uniform noise, the agent may can communicate one state neighbor to the prey
    end
    
    methods
        
        function self = PartialObsAgentMute(cardinal,comType,comMapping,comNoiseLevel)
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
        
    end
end


