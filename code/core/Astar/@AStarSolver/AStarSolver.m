classdef AStarSolver < handle
    %ASTARTSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        paths
        
        domain
        initState
        endState
        
        maxIter = 500;
        
    end
    
    methods
        
        function self = AStarSolver(domain, maxIter)
            self.domain = domain;
            if nargin > 1
                self.maxIter = maxIter;
            end
        end
        
        function action = solve_next_action(self, initState, endState)
            [bestPath, ~] = self.solve(initState, endState);
            if isempty(bestPath)
                warning('Solver did not converged, sending random action')
                action = randi(self.domain.environment.nActions);
            else
                action = bestPath.selectedActions(1);
            end
        end
        
        function [bestPath, nIterations] = solve(self, initState, endState)
            self.paths = {};
            self.paths{end+1} = Path(self.domain, 1:self.domain.environment.nActions, initState);
            
            nIterations = 0;
            while true
                self.remove_dead_path()
                cheapestPath = self.get_cheapest_path();
                if ismember(endState, cheapestPath.visitedStates(end, :), 'rows')
                    bestPath = cheapestPath;
                    return
                else
                    newPath = cheapestPath.extend_path(endState);
                    if ismember(endState, newPath.visitedStates(end, :), 'rows')
                        %only because I know cost will always be one!!
                        bestPath = newPath;
                        return
                    else
                        self.paths{end+1} = newPath;
                    end
                end
                nIterations = nIterations + 1;
                if nIterations > self.maxIter
                    bestPath = [];
                    return
                end
            end
        end
        
        function cheapestPath = get_cheapest_path(self)
            cheapestPathIdx = 0;
            minCost = Inf;
            for i = 1:length(self.paths)
                if  self.paths{i}.cost < minCost
                    cheapestPathIdx = i;
                    minCost = self.paths{i}.cost;
                end
            end
            cheapestPath = self.paths{cheapestPathIdx};
        end
        
        function remove_dead_path(self)
            toRemoveIdx = [];
            for i = 1:length(self.paths)
                if  ~self.paths{i}.is_alive()
                    toRemoveIdx(end+1) = i;
                end
            end
            for i = toRemoveIdx
                self.paths(i) = []; % paths is a cell but it work that way to delete an element
            end
        end
        
        
    end
    
end

