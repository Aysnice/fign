function [ main_stamm] = find_path( ends, adjacency_matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tmp_maxim=0;
tmp_max_ind=0;
new_paths=[];

for e=1:size(ends,2)
    s=ends(e);
    N = size(adjacency_matrix,1);
    visited=zeros(1,N);
    paths=cell(N,2);
    paths{s,1}=0;
    [paths, maxim, max_ind] = dfs( s, adjacency_matrix, visited, paths,0,0);
    
    if(maxim>tmp_maxim)
        tmp_maxim=maxim;
        tmp_max_ind=max_ind;
        new_paths=paths;
    end
    
end
if size(new_paths,1)>0
    main_stamm=new_paths{tmp_max_ind,2};
else
    main_stamm=[];
end
clear tmp_maxim tmp_max_ind N visited s new_paths maxim max_ind e 

end

