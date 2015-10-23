function [ ] = plot_ellipse_level(bw, ellipse_level, O_e, Color, lw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% figure
% imshow(bw),title('Euclidean'), hold on


for i=1:1:size(ellipse_level,1)
    
    a_pred = ellipse_level(i,1); 
    b_pred = ellipse_level(i,2);
    
    O2=[floor(ellipse_level(i,3)), O_e(1,2)];%floor(ellipse_level(i,4))];
    
    c=sqrt(a_pred^2-b_pred^2);
    
    f1x=O2(1,1)-c;
    f2x=O2(1,1)+c;
    
    f1y=O2(1,2);
    f2y=O2(1,2);
    
    
    [X,Y] = compute_ellipse(a_pred,b_pred,O2);%, Rot);
    plot(X,Y,'Color',Color,'LineWidth',lw), hold on
%     plot([f1x,f2x],[f1y,f2y],'*r'),hold on 
    %plot(f2x,f2y,'w*'),hold on 
  
end

end

