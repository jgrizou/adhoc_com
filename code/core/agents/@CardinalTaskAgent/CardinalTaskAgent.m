classdef CardinalTaskAgent < CardinalAgent
    %CARDINALTASKAGENT
    
    properties
        
        stucker
        
    end
    
    methods
        
        function self = CardinalTaskAgent(cardinal, stucker)
            self@CardinalAgent(cardinal)
            self.stucker = stucker;
        end
        
        function targetState = compute_target_state(self, domain)
            [nonStuckerState, stuckerState] = ...
                CardinalTaskAgent.get_cardinal_state_to_reach(domain.environment, ...
                                                                domain.lockingState, ...
                                                                domain.get_prey_state());            
            if self.stucker
                targetState = stuckerState(self.cardinal,:);
            else
                targetState = nonStuckerState(self.cardinal,:);
            end
        end       
    end
    
    methods(Static)
        
        function [nonStuckerState, stuckerState] = get_cardinal_state_to_reach(environment, lockingState, preyState)      
            nonStuckerState = zeros(4,2);
            stuckerState = zeros(4,2);            
            for iCardinal = 1:4
                targetState = environment.eval_next_state(preyState, iCardinal);
                % stucker
                stuckerState(iCardinal, :) = targetState;
                % non stucker
                if iCardinal == 1
                    if preyState(1) ~= lockingState(1)
                        targetState(1) = targetState(1) + 1;
                    end
                elseif iCardinal == 2
                    if preyState(1) ~= lockingState(1)
                        targetState(1) = targetState(1) - 1;
                    end
                elseif iCardinal == 3
                    if preyState(2) ~= lockingState(2)
                        targetState(2) = targetState(2) + 1;
                    end
                elseif iCardinal == 4
                    if preyState(2) ~= lockingState(2)
                        targetState(2) = targetState(2) - 1;
                    end
                end
                nonStuckerState(iCardinal, :) = environment.format_state(targetState);               
            end
        end
        
    end
end

