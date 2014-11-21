classdef AdhocAgent < BasicAgent
    %ADHOCAGENT
    
    properties
        
        visibleAreaActionSequence = [1,5;1,1;2,5;2,2;3,5;3,3;4,5;4,4;1,3;2,4;3,2;4,1;5,5]
        
        % we make a strong choice in the desing, the adhoc agent will always be the first agent in the domain
        % it is just easier to handle hand to not change anything with
        % respect to the possible team cnfiguration, infact, it ensure we
        % never end-up with twice the same team
        
        domainStructHypothesis
        nHypothesis
        
        logProbaHypothesis
        probaHypothesis
        
    end
    
    methods
        
        function self = AdhocAgent(domainStructHypothesis)
            self@BasicAgent(get_nice_color('p'))
            
            self.domainStructHypothesis = domainStructHypothesis;
            self.nHypothesis = length(domainStructHypothesis);
            
            self.logProbaHypothesis = zeros(1, self.nHypothesis);
            self.probaHypothesis = log_normalize_row(self.logProbaHypothesis);
        end
        
        function actionProba = compute_action_proba(self, domain, recorder)
            %for each world config with probability > 0 compute the action
            %proba and merge them to get the one of the adhoc
            actionProba = zeros(1,5);
            for i = 1:self.nHypothesis
                if ~isinf(self.logProbaHypothesis(i))
                    hypDomain = create_domain_from_struct(self.domainStructHypothesis{i});
                    hypDomain.load_domain_state(domain.get_domain_state());
                    % here comes the hypothesis that adhoc is agent 1
                    tmpActionProba = hypDomain.agents{1}.compute_action_proba(hypDomain, Logger());
                    actionProba = actionProba + tmpActionProba * self.probaHypothesis(i);
                end
            end
            stateReward = domain.environment.get_empty_state_reward(); recorder.logit(stateReward)
            obstacleProba = domain.environment.get_empty_obstacle_proba(); recorder.logit(obstacleProba)
            recorder.logit(actionProba)
        end
        
        function update_hypothesis_proba(self, prevDomainState, nextDomainState, ordering)
            prevLogProbaHypothesis = self.logProbaHypothesis;
            prevProbaHypothesis = self.probaHypothesis;
            for i = 1:self.nHypothesis
                add_counter(i, self.nHypothesis)
                if ~isinf(self.logProbaHypothesis(i))
                    % create hyp domain
                    hypDomain = AdhocAgent.create_adhoc_domain(self.domainStructHypothesis, i);
                    hypDomain.load_domain_state(prevDomainState); %% should take the domain state in rec
                    hypDomain.agents{1}.logProbaHypothesis = prevLogProbaHypothesis;
                    hypDomain.agents{1}.probaHypothesis = prevProbaHypothesis;
                    % update proba        
                    self.logProbaHypothesis(i) = self.logProbaHypothesis(i) + hypDomain.compute_log_proba_next_domain_state(nextDomainState, ordering);
                end
                remove_counter(i, self.nHypothesis)
            end
            self.probaHypothesis = log_normalize_row(self.logProbaHypothesis);
        end
        
        %%
        function visibleStates = get_visible_states(self, domain)
            visibleStates = domain.compute_visible_states(self.get_state(domain), self.visibleAreaActionSequence);
        end
        
        function invisibleStates = get_invisible_states(self, domain)
            visibleStates = self.get_visible_states(domain);
            invisibleStates = setdiff(1:domain.environment.nStates, visibleStates);
        end
        
        function isVisible = is_prey_visible(self, domain)
            isVisible = false;
            visibleStates = self.get_visible_states(domain);
            if any(domain.get_prey_state() == visibleStates)
                isVisible = true;
            end
        end
        
    end
    
    methods(Static)
        
        function adhocDomainStruct = create_adhoc_domain_struct(domainStructHypothesis, hypothesisSelected)
            adhocDomainStruct = domainStructHypothesis{hypothesisSelected};
            adhocDomainStruct.predators{1} = AdhocAgent(domainStructHypothesis);
        end
        
        function adhocDomain = create_adhoc_domain(domainStructHypothesis, hypothesisSelected)
            adhocDomainStruct = AdhocAgent.create_adhoc_domain_struct(domainStructHypothesis, hypothesisSelected);
            adhocDomain = create_domain_from_struct(adhocDomainStruct); 
        end
        
    end
end

