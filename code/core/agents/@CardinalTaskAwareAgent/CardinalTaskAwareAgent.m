classdef CardinalTaskAwareAgent < BasicAgent
    %CARDINALTASKAGENT
    
    properties
        % we assume the team is as follows:
        % the agent taking caridnal 1 is a stucker
        % the agent taking caridnal 2 is NOT a stucker
        % the agent taking caridnal 3 is a stucker
        % the agent taking caridnal 4 is NOT a stucker
        
        previousCardinal
        
    end
    
    methods
        
        function self = CardinalTaskAwareAgent()
            self@BasicAgent(get_nice_color('r'))
        end        

        function targetState = compute_target_state(self, domain)
            targetState = self.compute_target_state_given_prey_state(domain, domain.get_prey_state());
        end
        
        function targetState = compute_target_state_given_prey_state(self, domain, preyState)
            [nonStuckerState, stuckerState] = ...
                CardinalTaskAgent.get_cardinal_state_to_reach(domain.environment, ...
                                                                domain.lockingState, ...
                                                                preyState);
            
            validStates = [stuckerState(1, :); ...
                nonStuckerState(2, :); ...
                stuckerState(3, :); ...
                nonStuckerState(4, :); ];
            
            consistentState = [];
            if ~isempty(self.previousCardinal)
                consistentState = validStates(self.previousCardinal,:);
            end
            
            if ismember(self.get_state(domain), validStates, 'rows')
                targetState = self.get_state(domain);
            else
                % find closest unoccupied state
                occupiedStates = domain.get_occupied_states();
                freeValidStates = setdiff(validStates,occupiedStates, 'rows'); 
                
                manhattanDistances = domain.environment.distance_between_state(self.get_state(domain), freeValidStates);                      
                closestIdx = find(manhattanDistances == min(manhattanDistances));
                
                if ~isempty(consistentState) && ismember(consistentState, freeValidStates(closestIdx,:), 'rows')
                    %stay consistent
                    targetState = consistentState;
                else
                    %choose at random
                    idx = randsample(closestIdx, 1);
                    targetState = freeValidStates(idx,:);  
                end
            end
            [~, self.previousCardinal] = ismember(targetState, validStates, 'rows');
        end  
       
    end
end

