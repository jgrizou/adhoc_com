classdef AdhocAgent < BasicAgent
    %ADHOCAGENT
    
    
    properties
        
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
        
        function actionProba = compute_action_proba(self, domain)
            %for each world config with porbability > 0 compute the action
            %proba and merge them to get the one of the adhoc
            actionProba = zeros(1,5);
            for i = 1:self.nHypothesis
                if ~isinf(self.logProbaHypothesis(i))
                    hypDomain = create_domain_from_struct(self.domainStructHypothesis{i});
                    hypDomain.load_domain_state(domain.get_domain_state());
                    % here comes the hypothesis that adhoc is agent 1
                    tmpActionProba = hypDomain.agents{1}.compute_action_proba(hypDomain);
                    actionProba = actionProba + tmpActionProba * self.probaHypothesis(i);
                end
            end
        end
        
        function update_hypothesis_proba(self, prevDomainState, nextDomainState, ordering)
            for i = 1:self.nHypothesis
                add_counter(i, self.nHypothesis)
                if ~isinf(self.logProbaHypothesis(i))
                    hypDomain = AdhocAgent.create_adhoc_domain(self.domainStructHypothesis, i);
                    hypDomain.load_domain_state(prevDomainState); %% should take the domain state in rec
                    self.logProbaHypothesis(i) = self.logProbaHypothesis(i) + hypDomain.compute_log_proba_next_domain_state(nextDomainState, ordering);
                end
                remove_counter(i, self.nHypothesis)
            end
            self.probaHypothesis = log_normalize_row(self.logProbaHypothesis);
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

