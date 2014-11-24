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
        
        function targetStates = compute_target_states(self, domain)
            [nonStuckerState, stuckerState] = ...
                CardinalTaskAgent.get_cardinal_state_to_reach(domain.environment, ...
                                                                domain.lockingState, ...
                                                                domain.get_prey_state());            
            if self.stucker
                targetStates = stuckerState(self.cardinal);
            else
                targetStates = nonStuckerState(self.cardinal);
            end
        end
    end
    
    methods(Static)
        
        function [nonStuckerState, stuckerState] = get_cardinal_state_to_reach(environment, lockingState, preyState)      
            nonStuckerState = zeros(4,1);
            stuckerState = zeros(4,1);
            
            for iCardinal = 1:4
                targetState = environment.eval_next_state_no_noise(preyState, iCardinal);
                % stucker
                stuckerState(iCardinal, :) = targetState;
                % non stucker
                preyPosition = environment.state_to_position(preyState);
                lockingPosition = environment.state_to_position(lockingState);
                if iCardinal == 1
                    if preyPosition(1) ~= lockingPosition(1)
                        %% leave one square free for the prey to move
                        targetState = environment.eval_next_state_no_noise(targetState, iCardinal);
                    end
                elseif iCardinal == 2
                    if preyPosition(1) ~= lockingPosition(1)
                        %% leave one square free for the prey to move
                        targetState = environment.eval_next_state_no_noise(targetState, iCardinal);
                    end
                elseif iCardinal == 3
                    if preyPosition(2) ~= lockingPosition(2)
                        %% leave one square free for the prey to move
                        targetState = environment.eval_next_state_no_noise(targetState, iCardinal);
                    end
                elseif iCardinal == 4
                    if preyPosition(2) ~= lockingPosition(2)
                        %% leave one square free for the prey to move
                        targetState = environment.eval_next_state_no_noise(targetState, iCardinal);
                    end
                end
                nonStuckerState(iCardinal, :) = targetState;
            end
        end
        
    end
end