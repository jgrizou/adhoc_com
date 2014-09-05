classdef BasicAgent < handle %matlab.mixin.Copyable
    %@BASICAGENT
    
    properties
        id
        domain
        state
        
        color = get_random_color()
    end
    
    methods
        
        function self = BasicAgent(domain, color)
            self.domain = domain;
            if nargin > 1
                self.color = color;
            end
        end
                
        function draw(self)
            if ~isempty(self.state)
                if ~isempty(self.id)
                    self.domain.environment.drawer.draw_square(self.state, [1,1,1], num2str(self.id))
                end
                posId = self.domain.environment.drawer.get_id(self.state);
                self.domain.environment.drawer.draw_dot(posId, self.color)
            end
        end
        
    end
    
%     methods(Access = protected)
%         % Override copyElement method:
%         function copySelf = copyElement(self)
%             % Make a shallow copy of all four properties
%             copySelf = copyElement@matlab.mixin.Copyable(self);
%         end
%     end
        
end

