function [ ellipse_level ] = optimize_level( ellipse_level,bw )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

s=size(ellipse_level,1);
ellipse_level(:,5)=ellipse_level(:,1).*ellipse_level(:,2);
[values, order] = sort(ellipse_level(:,5));
ellipse_level = ellipse_level(order,:)


for i=1:1:s
    Im=bw;
    for j=1:1:s
        if(j~=i)
%             figure 
%             imshow(Im)
            
            O=[floor(ellipse_level(j,3)), floor(ellipse_level(j,4))];
            [X,Y] = compute_ellipse(ellipse_level(j,1), ellipse_level(j,1), O);%, Rot);
            bw_1 = poly2mask(double(X), double(Y), size(bw,1), size(bw,2));
            
            Im_tmp=imsubtract(logical(Im),bw_1);
            Im=immultiply(logical(Im),Im_tmp);
            
%             figure 
%             imshow(Im)
        end
    end
    

    
    O2=[floor(ellipse_level(i,3)), floor(ellipse_level(i,4))];
    [a_pred,b_pred]=optimize_fit( Im, ellipse_level(i,1), ellipse_level(i,2), O2 );
    ellipse_level(i,1)=a_pred;
    ellipse_level(i,2)=b_pred;    
    
end
    

end

