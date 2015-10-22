function [ ellipse_level] = finish_representation(ellipse_level,DT)
%FINISH_REPRESENTATION Summary of this function goes here
%   Detailed explanation goes here

ellipse_level_lines=[];
step=5;

for i=1:1:size(ellipse_level,1)-1
    
    a1 = ellipse_level(i,1);
    b1 = ellipse_level(i,2);
    if (b1>a1)
        c = 0;
    else
        c = sqrt(a1^2-b1^2);
    end
    
    right_x = round(ellipse_level(i,3) + c);
    border_1 = round(ellipse_level(i,3) + a1);
    
    a2 = ellipse_level(i+1,1);
    b2 = ellipse_level(i+1,2);
    if (b2>a2)
        c = 0;
    else
        c = sqrt(a2^2-b2^2);
    end
    
    left_x = round(ellipse_level(i+1,3) - c);
    border_2 = round(ellipse_level(i+1,3) - a2);
    
    for w=right_x:step:left_x
        
        if(w<=border_1)
            h=abs(b1*(sqrt(1-(w-ellipse_level(i,3))^2/a1^2)));
        elseif(w>=border_2)
            h=abs(b2*(sqrt(1-(w-ellipse_level(i+1,3))^2/a2^2)));
        else
            h=0;
        end
        
        b=max(DT(:, w));
        a=0;
        
        if(b>h)
            
            ind_o=find(DT(:,w)==max(DT(:,w)) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level_lines=[ellipse_level_lines ; a b round(w) y_];
        end
    end
    
end

ellipse_level=[ellipse_level; ellipse_level_lines];

end

