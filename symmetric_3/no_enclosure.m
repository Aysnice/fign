function [ ellipse_level ] =no_enclosure( ellipse_level )
%FIND_POSITIVE_CURVATURE Summary of this function goes here
%   Detailed explanation goes here

frags=[];

for i=1:1:size(ellipse_level,1)
    
    a = ellipse_level(i,1);
    b = ellipse_level(i,2);
    
    left_x  = ellipse_level(i,3) - a;
    right_x = ellipse_level(i,3) + a;
    
    up_y  = abs(ellipse_level(i,4) - b);
    down_y = abs(ellipse_level(i,4) + b);
    
    
    for j=1:1:size(ellipse_level,1)
        if(i==j)
            continue;
        else
            a2 = ellipse_level(j,1);
            b2 = ellipse_level(j,2);
            
            left_x2  = ellipse_level(j,3) - a2;
            right_x2 = ellipse_level(j,3) + a2;
            
            up_y2  = abs(ellipse_level(j,4) - b2);
            down_y2 = abs(ellipse_level(j,4) + b2);
            
            if(left_x2>=left_x && right_x2<=right_x)
          %      if(up_y2<=up_y && down_y2<=down_y)
                    frags=[frags,j];
           %     end
            end
        end
        
    end
    
end

ellipse_level(frags,:)=[];

end

