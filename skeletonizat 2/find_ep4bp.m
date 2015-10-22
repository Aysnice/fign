function [ ind ] = find_ep4bp( bp, dt, endpoints )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ind=[];

for p=1:size(endpoints,1)
    ed=pdist2(bp,[endpoints(p,1),endpoints(p,2)]);
    if (ed<=dt*sqrt(2))
        ind=[ind p];
    end
end

end

