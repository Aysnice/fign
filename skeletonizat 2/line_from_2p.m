function [ new_x, new_y ] = line_from_2p( x1, y1, x2, y2,bw)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Ax+By+C=0
% A=y2-y1
% B=x2-x1
% C=x1y2 - x2y1

if (x1==x2)
    if(y2 < y1)
        new_y=1:y1;
    else
        new_y=y1:size(bw,2);
    end
    
    new_x=repmat(x2,[1,size(new_y,2)]);
    
elseif(y1==y2)
    
    if(x2 < x1)
        new_x=1:x1;
    else
        new_x=x1:size(bw,1);
    end
    
    new_y=repmat(y2,[1,size(new_x,2)]);
else
    A=y1-y2;
    B=x1-x2;
    
    %     if(A>B)
    if(y1<y2)
        new_y = y1:size(bw,2);
    else
        new_y = 1:y1;
    end
    
    new_x=x1+(B/A)*(new_y-y1);
    
    %     else
    %         if(x1<x2)
    %             new_x = x1:size(bw,1);
    %         else
    %             new_x = 1:x1;
    %         end
    %
    %         new_y=y1+(A/B)*(new_x-x1);
    %     end
end

ind_neg=find(new_y<1);
new_x(ind_neg)=[]; new_y(ind_neg)=[]; new_y=round(new_y);

ind_neg=find(new_x<1);
new_x(ind_neg)=[]; new_y(ind_neg)=[]; new_x=round(new_x);

ind_pos=find(new_y>size(bw,2));
new_x(ind_pos)=[]; new_y(ind_pos)=[]; new_y=round(new_y);

ind_pos=find(new_x>size(bw,1));
new_x(ind_pos)=[]; new_y(ind_pos)=[]; new_x=round(new_x);


end

