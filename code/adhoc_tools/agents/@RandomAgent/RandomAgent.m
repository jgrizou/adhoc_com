classdef RandomAgent < BasicAgent
    
    properties
    end
    
    methods
        
        function self = RandomAgent(color)
            if nargin < 1
                color = get_random_color;
            end
            self@BasicAgent(color)           
        end
        
        function actionProba = compute_action_proba(~, domain, recorder)
            actionProba = proba_normalize_row(ones(1,domain.environment.nActions));
            recorder.logit(actionProba)
        end
        
    end    
end

