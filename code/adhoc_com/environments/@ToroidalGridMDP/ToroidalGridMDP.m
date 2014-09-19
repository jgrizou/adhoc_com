classdef ToroidalGridMDP < handle
    %TOROIDALGRIDMDP
    
    properties
        
        gridSize
        
        %the following variable must keep the same name to be used with
        %Value Iteration Solver
        Gamma = 0.95 % Discount factor - for Value Iteration (VI) solver
        nS % Number of state
        nA = 5 % Number of action
        P % Transisiton matrix
        R % Reward
        
        
        noiseLevel
        
        % used to calcualte the transition
        ToroidalModel
        
        obstacleStates
        
    end
    
    methods
        
        function self = ToroidalGridMDP(gridSize, noiseLevel)
            self.gridSize = gridSize;
            self.nS = self.gridSize.^2;
            self.noiseLevel = noiseLevel;
            self.ToroidalModel = ToroidalGrid(gridSize);
        end
        
        %%
        function state = position_to_state(self, position)
            position = position - [1,1];
            state = position(1) * self.gridSize + position(2) + 1;
        end
        
        function position = state_to_position(self, state)
            tmp = (state-1)/self.gridSize;
            position(1) = floor(tmp) + 1;
            position(2) = round((tmp - floor(tmp))*self.gridSize) + 1;
        end
        
        %%
        function add_obstacle_at_position(self, position)
            self.add_obstacle_at_state(self.position_to_state(position));
        end
        
        function add_obstacle_at_state(self, state)
            self.obstacleStates(end+1)  = state;
        end
        
        %%
        function set_unitary_sparse_reward_at_position(self, position)
            R = zeros(self.nS, 1);
            R(self.position_to_state(position)) = 1;
            self.set_reward(R);
        end
        
        function set_unitary_sparse_reward_at_state(self, state)
            R = zeros(self.nS, 1);
            R(state) = 1;
            self.set_reward(R);
        end
        
        function set_reward(self, R)
            self.R = R;
        end
        
        %%
        function build_MDP(self)
            %Initialize transition matrix
            self.P{1} = sparse(self.nS,self.nS);           % +x
            self.P{2} = sparse(self.nS,self.nS);           % -x
            self.P{3} = sparse(self.nS,self.nS);           % +y
            self.P{4} = sparse(self.nS,self.nS);           % -y
            self.P{5} = speye(self.nS,self.nS);            % NOOP action
            %
            for action = 1:4 % P{5} is already ok
                for startState = 1:self.nS
                    actionProba = ToroidalGridMDP.generate_action_proba_for_action(action, self.noiseLevel);
                    for actionTaken = 1:4 % P{5} is already ok
                        if actionProba(actionTaken) > 0
                            startPosition = self.state_to_position(startState);
                            nextPosition = self.ToroidalModel.eval_next_state(startPosition, actionTaken);
                            nextState = self.position_to_state(nextPosition);
                            if any(nextState == self.obstacleStates)
                                nextState = startState;
                            end
                            self.P{action}(startState,nextState) = ...
                                self.P{action}(startState,nextState) + actionProba(actionTaken);
                        end
                    end
                end
            end
        end
        
    end
    
    methods(Static)
        
        function actionProba = generate_action_proba_for_action(action, noiseLevel)
            %the noise is not uniform.
            % a stop action (5) always succeed
            % a directional action (1,2,3,4) suceed with 1-noiseLevel
            % and the two orthogonal actions get noiseLevel/2
            % actions can be 1,2,3,4,5 for +x, -x, +y, -y, nop
            allActionsProba = ToroidalGridMDP.generate_all_actions_proba(noiseLevel);
            actionProba = allActionsProba(action,:);
        end
        
        function allActionsProba = generate_all_actions_proba(noiseLevel)
            %hardcoded
            allActionsProba = zeros(5,5);
            successProba = 1 - noiseLevel;
            sideProba = noiseLevel/2;
            
            allActionsProba(1, :) = [successProba, 0, sideProba, sideProba, 0];
            allActionsProba(2, :) = [0, successProba, sideProba, sideProba, 0];
            allActionsProba(3, :) = [sideProba, sideProba, successProba, 0, 0];
            allActionsProba(4, :) = [sideProba, sideProba, 0, successProba, 0];
            allActionsProba(5, :) = [0, 0, 0, 0, 1];            
        end
        
    end
end



