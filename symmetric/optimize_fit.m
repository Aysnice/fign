function [a_pred,b_pred] = optimize_fit( bw, a, b, O )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

some_matrix=[];

a_pred=a;
b_pred=b;

step=5;

%------------VERSION 1------------------------------------
% 
% for a_pred=a-25:step:a+25
%     for b_pred=b-25:step:b+50
%         [out_values leftover_values total_shit]=compute_residuals(bw,a_pred,b_pred,O);
%         some_matrix=[some_matrix; a_pred b_pred out_values leftover_values total_shit];
%     end
% end
% % % figure
% % % A=some_matrix(:,1); B=some_matrix(:,2); C=some_matrix(:,3);
% % % plot3(A,B,C,'r'), hold on
% % % A=some_matrix(:,1); B=some_matrix(:,2); C=some_matrix(:,4);
% % % plot3(A,B,C,'b'), hold on
% % 
% % 
% [x,y]=find(some_matrix==min(some_matrix(:,5)));
% 
% a_pred=some_matrix(x,1);
% b_pred=some_matrix(x,2);


%------------VERSION 2------------------------------------
% prev=999999999999999999999999999999; cur=99999999999999999999999999999;
% 
% [out_values leftover_values up]=compute_residuals(bw,a_pred,b_pred+step,O);
% [out_values leftover_values down]=compute_residuals(bw,a_pred,b_pred-step,O);
% 
% if up>down
%     direction='down';
% else
%     direction='up';
% end
% 
% while prev>cur
%     prev=cur;
%     [out_values leftover_values total_shit]=compute_residuals(bw,a_pred,b_pred,O);
%     cur=total_shit;
%     some_matrix=[some_matrix; a_pred b_pred out_values leftover_values total_shit];
%     
%     if(strcmp(direction,'up'))
%         b_pred=b_pred+step;
%     else
%         b_pred=b_pred-step;
%     end
% end
% 
% some_matrix(end,:)=[];
% b_pred=some_matrix(end,2);
% 
% some_matrix=[];
% prev=999999999999999999999999999999; cur=99999999999999999999999999999;
% 
% [out_values leftover_values up]=compute_residuals(bw,a_pred+step,b_pred,O);
% [out_values leftover_values down]=compute_residuals(bw,a_pred-step,b_pred,O);
% 
% if up>down
%     direction='down';
% else
%     direction='up';
% end
% 
% while prev>cur
%     prev=cur;
%     [out_values leftover_values total_shit]=compute_residuals(bw,a_pred,b_pred,O);
%     cur=total_shit;
%     some_matrix=[some_matrix; a_pred b_pred out_values leftover_values total_shit];
%     if(strcmp(direction,'up'))
%         a_pred=a_pred+step;
%     else
%         a_pred=a_pred-step;
%     end
% end
% 
% some_matrix(end,:)=[];
% % 
% a_pred=some_matrix(end,1);


%------------VERSION 3------------------------------------
% a_pred_min; a_pred_max; step_a;
% b_pred_min; b_pred_max; step_b;

%-------------AAAAAAAAAAAAAAAAAAAAAAAAAAAA-----------------
[out_values leftover_values up]=compute_residuals(bw,a_pred+step,b_pred,O);
[out_values leftover_values down]=compute_residuals(bw,a_pred-step,b_pred,O);

if up>down
%     direction='down';
    a_pred_min=a_pred;
    a_pred_max=a_pred-20;
    step_a=-step;
else
%     direction='up';
    a_pred_min=a_pred;
    a_pred_max=a_pred+20;
    step_a=step;
end
%---------------BBBBBBBBBBBBBBBBBBBBBB--------------------
[out_values leftover_values up]=compute_residuals(bw,a_pred,b_pred+step,O);
[out_values leftover_values down]=compute_residuals(bw,a_pred,b_pred-step,O);
if up>down
%     direction='down';
    b_pred_min=b_pred;
    b_pred_max=b_pred-20;
    step_b=-step;
else
%     direction='up';
    b_pred_min=b_pred;
    b_pred_max=b_pred+20;
    step_b=step;
end

for a_pred=a_pred_min:step_a:a_pred_max
    for b_pred=b_pred_min:step_b:b_pred_max
        [out_values leftover_values total_shit]=compute_residuals(bw,a_pred,b_pred,O);
        some_matrix=[some_matrix; a_pred b_pred out_values leftover_values total_shit];
    end
end

[x,y]=find(some_matrix==min(some_matrix(:,4)));

a_pred=some_matrix(x(1),1);
b_pred=some_matrix(x(1),2);

end

