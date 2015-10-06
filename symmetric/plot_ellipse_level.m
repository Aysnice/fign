function [ ] = plot_ellipse_level(bw, ellipse_level, O, O_e, Color, lw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure
imshow(bw),title('Euclidean'), hold on
%imshow(bw_crop),hold on


for i=1:1:size(ellipse_level,1)
    
    a_pred = ellipse_level(i,1); 
    b_pred = ellipse_level(i,2);
    
    O2=[floor(ellipse_level(i,3)), floor(ellipse_level(i,4))];
    clear x_ y_
    dO=pdist2(O_e,O2);
    
    dOx=0;%dO*Rot(1,1);
    dOy=0;%dO*Rot(1,2);
    
    if(O_e(1)-O2(1)>0)
        O_new=[O(1)-dOx,0];
    else
        O_new=[O(1)+dOx,0];
    end
    
    if(O_e(2)-O2(2)>0)
        O_new(2)=O(2)-dOy;
    else
        O_new(2)=O(2)+dOy;
    end
    
%   [a_pred,b_pred]=optimize_fit( bw, a_pred, b_pred, O2 );
    
    [X,Y] = compute_ellipse(a_pred,b_pred,O2);%, Rot);
    plot(X,Y,'Color',Color,'LineWidth',lw),
%   plot(O2(1),O2(2),'b*'),hold on 
  
end

end

