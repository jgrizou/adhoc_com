classdef AutoCardinalTaskAgent < CardinalAgent
    %AUTOCARDINALTASKAGENT
    
    properties
    end
    
    methods
        
        function self = AutoCardinalTaskAgent(cardinal)
            self@CardinalAgent(cardinal)
        end
        
        function targetState = compute_target_state(self, domain)
            targetState = self.compute_target_state_given_prey_state(domain, domain.get_prey_state());
        end
        
        function targetState = compute_target_state_given_prey_state(self, domain, preyState)
            
            [nonStuckerState, stuckerState] = ...
                CardinalTaskAgent.get_cardinal_state_to_reach(domain.environment, ...
                domain.lockingState, ...
                preyState);
            
            stuckerPerCardinal = AutoCardinalTaskAgent.get_stucker_per_cardinal(domain, preyState);
            
            if stuckerPerCardinal(self.cardinal)
                targetState = stuckerState(self.cardinal, :);
            else
                targetState = nonStuckerState(self.cardinal, :);
            end
        end
    end
    
    methods(Static)
        
        function stuckerPerCardinal = get_stucker_per_cardinal(domain, preyState)
            
            stuckerPerCardinal = nan(4,1); % nan just to be sure we fill everything
                        
            % x dim stucker (for cardinal 1 and 2)
            [dx, direction] = domain.environment.delta_x(preyState, domain.lockingState);
            if dx == domain.environment.gridSize/2;
                stuckerPerCardinal(1) = 0;
                stuckerPerCardinal(2) = 0;
            elseif direction > 0
                stuckerPerCardinal(1) = 0;
                stuckerPerCardinal(2) = 1;
            elseif direction < 0
                stuckerPerCardinal(1) = 1;
                stuckerPerCardinal(2) = 0;
            elseif dx == 0
                stuckerPerCardinal(1) = 1;
                stuckerPerCardinal(2) = 1;
            end
            
            % y dim stucker (for cardinal 3 and 4)
            [dy, direction] = domain.environment.delta_y(preyState, domain.lockingState);
            if dy == domain.environment.gridSize/2;
                stuckerPerCardinal(3) = 0;
                stuckerPerCardinal(4) = 0;
            elseif direction > 0
                stuckerPerCardinal(3) = 0;
                stuckerPerCardinal(4) = 1;
            elseif direction < 0
                stuckerPerCardinal(3) = 1;
                stuckerPerCardinal(4) = 0;
            elseif dy == 0
                stuckerPerCardinal(3) = 1;
                stuckerPerCardinal(4) = 1;
            end
            
            % check
            if any(isnan(stuckerPerCardinal))
                stuckerPerCardinal
                error('stuckerPerCardinal not fully filled')
            end
            
        end
        
    end
    
end

