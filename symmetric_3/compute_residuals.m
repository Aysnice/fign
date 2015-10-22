function [ out_values leftover_values total_shit ] = compute_residuals(bw,a_pred,b_pred,O)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[X,Y] = compute_ellipse(a_pred, b_pred, O);%, Rot);
bw_1 = poly2mask(double(X), double(Y), size(bw,1), size(bw,2));

OUT=imsubtract(bw_1,logical(bw));
ind=find(OUT==1);
out_values=sum(ind);%bg

OUT=imsubtract(logical(bw),bw_1);
ind=find(OUT==1);
leftover_values=sum(ind); %nashi

total_shit=out_values+leftover_values;

end

