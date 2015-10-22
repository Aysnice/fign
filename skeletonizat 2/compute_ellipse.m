function [X,Y] = compute_ellipse(a_pred, b_pred, O)%, Rot)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

 t=0;
    X=[]; Y=[];

    while t<2*pi
        tmpx=a_pred*cos(t);
        X=[X; tmpx];
    
        tmpy=b_pred*sin(t);
        Y=[Y; tmpy];
    
        t=t+0.01*pi;

    end
    G=[X Y]'; 
   % G=Rot*[X Y]'; 
    
    G=bsxfun(@plus,G,[O(1); O(2)]);

    X=G(1,:);Y=G(2,:);
end

