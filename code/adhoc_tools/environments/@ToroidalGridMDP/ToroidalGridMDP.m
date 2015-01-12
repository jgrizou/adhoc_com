classdef ToroidalGridMDP < handle
    %TOROIDALGRIDMDP
    
    properties
        
        gridSize
        nStates
        nActions = 5
        
        % positions are expressed as [x,y] coordinate in integer
        % actions can be 1,2,3,4,5 for +x, -x, +y, -y, nop
        actionEffects = ...
            [ 1, 0;
            -1, 0;
            0, 1;
            0,-1;
            0, 0]
                
        noiseLevel
        
        obstaleFreeMDPNoNoise % used to simulated the domain, with several agents
        obstaleFreeMDPWithNoise % used for the planning, computing optimal policies
        %we need those two becaue crateting a full mdp including all agent
        %and capture state would results in more than 2*10^8 states..
        %planning will consider other agent as obstacles.
        
        drawer
    end
    
    methods
        
        function self = ToroidalGridMDP(gridSize, noiseLevel)
            self.gridSize = gridSize;
            self.nStates = self.gridSize.^2;
            self.noiseLevel = noiseLevel;
            self.init_obstacle_free_MDPs()
            self.drawer = Squares_plot(self.list_all_positions());
        end
        
        function blankMDP = build_blank_MDP(self)
            %For alue Iteration Solver
            blankMDP = struct;
            blankMDP.Gamma = 0.95; % Discount factor - for Value Iteration (VI) solver
            blankMDP.nS = self.nStates; % Number of state
            blankMDP.nA = self.nActions; % Number of action
            blankMDP.P = cell(blankMDP.nA, 1); % Transisiton matrix
            blankMDP.R = self.get_empty_state_reward();% Reward can be on state or state-action pairs
            %Initialize transition matrix
            blankMDP.P{1} = sparse(blankMDP.nS,blankMDP.nS);           % +x
            blankMDP.P{2} = sparse(blankMDP.nS,blankMDP.nS);           % -x
            blankMDP.P{3} = sparse(blankMDP.nS,blankMDP.nS);           % +y
            blankMDP.P{4} = sparse(blankMDP.nS,blankMDP.nS);           % -y
            blankMDP.P{5} = speye(blankMDP.nS,blankMDP.nS);            % NOOP action
        end
        
        function init_obstacle_free_MDPs(self)
            self.obstaleFreeMDPNoNoise = self.build_blank_MDP();
            self.obstaleFreeMDPWithNoise = self.build_blank_MDP();
            % build transition with no obstacle but noise
            for action = 1:4 % P{5} is already ok
                for startState = 1:self.nStates
                    % noise free model
                    startPosition = self.state_to_position(startState);
                    nextPosition = self.eval_next_position(startPosition, action);
                    nextState = self.position_to_state(nextPosition);
                    self.obstaleFreeMDPNoNoise.P{action}(startState,nextState) = 1;
                    
                    % noisy model
                    actionProba = self.generate_action_proba_for_action(action);
                    for actionTaken = 1:4 % P{5} is already ok
                        if actionProba(actionTaken) > 0
                            startPosition = self.state_to_position(startState);
                            nextPosition = self.eval_next_position(startPosition, actionTaken);
                            nextState = self.position_to_state(nextPosition);
                            % two action never have the same effect,
                            % therefore we can assign the value directly
                            % and not do a P{a}(sS, nS) = P{a}(sS, nS) + proba
                            self.obstaleFreeMDPWithNoise.P{action}(startState,nextState) = actionProba(actionTaken);
                        end
                    end
                end
            end
            if ~is_MDP_valid(self.obstaleFreeMDPNoNoise)
                error('something wrong with obstaleFreeMDPNoNoise')
            end
            if ~is_MDP_valid(self.obstaleFreeMDPWithNoise)
                error('something wrong with obstaleFreeMDPWithNoise')
            end
        end
        
        function emptyReward = get_empty_state_reward(self)
            emptyReward = zeros(self.nStates,1);
        end
        
        %% generate obsctale mdp
        % these function only consider the MDP with noise which is used for deriving optial policies
        
        function MDP = get_noise_mdp_with_obstacle_and_reward(self, stateReward, obstacleProba)
            MDP = self.include_probabilistic_obstacles(self.obstaleFreeMDPWithNoise, obstacleProba);
            MDP.R = stateReward;
        end
        
        function MDP = include_probabilistic_obstacles(~, MDP, obstacleProba) % yes self is unused but lets keep it a non static method
            %obstacleProba is a (1, nStates proba vector)
            for a = 1:length(MDP.P)
                for startState = 1:size(MDP.P{a}, 1)
                    hitObstacleProba = MDP.P{a}(startState, :) * obstacleProba'; % yes we sum all because they result in a failed action, so stay in same place
                    actionSuccessProba = MDP.P{a}(startState, :) .* (1-obstacleProba);
                    
                    MDP.P{a}(startState, :) =  actionSuccessProba;
                    MDP.P{a}(startState, startState) =  MDP.P{a}(startState, startState) + hitObstacleProba;
                end
            end
            if ~is_MDP_valid(MDP)
                error('something wrong with MDP')
            end
        end
        
        function emptyObstacleProba = get_empty_obstacle_proba(self)
            emptyObstacleProba = zeros(1, self.nStates);
        end
        
        %% noise model
        function actionProba = generate_action_proba_for_action(self, action)
            %the noise is not uniform.
            % a stop action (5) always succeed
            % a directional action (1,2,3,4) suceed with 1-noiseLevel
            % and the two orthogonal actions get noiseLevel/2
            % actions can be 1,2,3,4,5 for +x, -x, +y, -y, nop
            allActionsProba = self.generate_all_actions_proba();
            actionProba = allActionsProba(action,:);
        end
        
        function allActionsProba = generate_all_actions_proba(self)
            %hardcoded
            allActionsProba = zeros(5,5);
            successProba = 1 - self.noiseLevel;
            sideProba = self.noiseLevel/2;
            
            allActionsProba(1, :) = [successProba, 0, sideProba, sideProba, 0];
            allActionsProba(2, :) = [0, successProba, sideProba, sideProba, 0];
            allActionsProba(3, :) = [sideProba, sideProba, successProba, 0, 0];
            allActionsProba(4, :) = [sideProba, sideProba, 0, successProba, 0];
            allActionsProba(5, :) = [0, 0, 0, 0, 1];
        end
        
        %% position tools, those functions assume no noise in the system, it is just easier to code transition that way
        function state = position_to_state(self, position)
            position = position - [1,1];
            state = position(1) * self.gridSize + position(2) + 1;
        end
        
        function position = state_to_position(self, state)
            tmp = (state-1)/self.gridSize;
            position(1) = floor(tmp) + 1;
            position(2) = round((tmp - floor(tmp))*self.gridSize) + 1; % round to ensure integer
        end
        
        function nextPosition = eval_next_position(self, startPosition, action)
            nextPosition = startPosition + self.actionEffects(action,:);
            nextPosition = self.format_position(nextPosition);
        end
        
        function state = format_position(self, position)
            state = mod(position - [1,1], self.gridSize) + [1,1];
        end
        
        function positions = list_all_positions(self)
            positions = zeros(self.nStates,2);
            for s = 1:self.nStates
                positions(s,:) = self.state_to_position(s);
            end
        end
        
        %%
        function [dx, direction] = delta_x_state(self, initState, goalState)
            initPosition = self.state_to_position(initState);
            goalPosition = self.state_to_position(goalState);
            [dx, direction] = self.delta_x_position(initPosition, goalPosition);
        end
        
        function [dx, direction] = delta_x_position(self, initPosition, goalPosition)
            dx = goalPosition(1) - initPosition(1);
            direction = sign(dx);
            dx = abs(dx);
            if dx > self.gridSize/2
                dx = self.gridSize - dx;
                direction = -direction;
            end
        end
        
        function [dy, direction] = delta_y_state(self, initState, goalState)
            initPosition = self.state_to_position(initState);
            goalPosition = self.state_to_position(goalState);
            [dy, direction] = self.delta_y_position(initPosition, goalPosition);
        end
        
        function [dy, direction] = delta_y_position(self, initPosition, goalPosition)
            dy = goalPosition(2) - initPosition(2);
            direction = sign(dy);
            dy = abs(dy);
            if dy > self.gridSize/2
                dy = self.gridSize - dy;
                direction = -direction;
            end
        end
        
        %% Warning these function are made such that [1,1] in relative is the reference!!
        function absoluteState = relative_to_absolute_state(self, referenceState, relativeState)
            referencePosition = self.state_to_position(referenceState);
            relativePosition = self.state_to_position(relativeState);
            absolutePosition = self.relative_to_absolute_position(referencePosition, relativePosition);
            absoluteState = self.position_to_state(absolutePosition);
        end
            
        function absolutePosition = relative_to_absolute_position(self, referencePosition, relativePosition)
            absolutePosition = self.format_position(referencePosition + relativePosition - [1,1]);
        end
        
        function relativeState = absolute_to_relative_state(self, referenceState, absoluteState)
            referencePosition = self.state_to_position(referenceState);
            absolutePosition = self.state_to_position(absoluteState);
            relativePosition = self.absolute_to_relative_position(referencePosition, absolutePosition);
            relativeState = self.position_to_state(relativePosition);
        end
        
        function relativePosition = absolute_to_relative_position(self, referencePosition, absolutePosition)
            relativePosition = self.format_position(absolutePosition - referencePosition + [1,1]);
        end
        
        %%
        
        function allStates = get_all_states(self)
            allStates = 1:self.nStates;
        end
        
        function randomState = get_random_state(self)
            randomState = randi(self.nStates);
        end
        
        function neighborStates = get_neighbor_states(self, state)
            neighborStates = zeros(4,1);
            neighborStates(1) = self.eval_next_state_no_noise(state, 1); %+x
            neighborStates(2) = self.eval_next_state_no_noise(state, 2); %-x
            neighborStates(3) = self.eval_next_state_no_noise(state, 3); %+y
            neighborStates(4) = self.eval_next_state_no_noise(state, 4); %-y
        end
        
        function nextState = eval_next_state_no_noise(self, startState, action)
            nextState = sample_next_state(self.obstaleFreeMDPNoNoise, startState, action);
        end
        
        function nextState = eval_next_state_with_noise(self, startState, action)
            nextState = sample_next_state(self.obstaleFreeMDPWithNoise, startState, action);
        end
        
    end
    
end



