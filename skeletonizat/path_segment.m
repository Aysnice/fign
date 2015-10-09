classdef path_segment< dynamicprops
   
    properties (Access = public)
        start_p %starting point index
        end_p   %end point index
        
        path_x
        path_y
        
    end
    
    methods
        
        function new_segment=path_segment(p)
          new_segment.start_p=p; 
          new_segment.end_p=0;   
        
          new_segment.path_x=[];
          new_segment.path_y=[];

        end
        
        function this_segment=add_point(this_segment,coord)
          this_segment.path_x(end+1)=coord(1);
          this_segment.path_y(end+1)=coord(2);
        end
    
    
    end
    
end
