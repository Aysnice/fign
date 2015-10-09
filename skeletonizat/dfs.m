function [paths, maxim, max_ind] = dfs( sp, adj_matrix, visited, paths, maxim, max_ind )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n = size(adj_matrix,1);
visited(sp)=1;
hasAdj=0;

for r=1:n
    if ((adj_matrix(sp,r)~=0) && (visited(r)==0))
        paths{r,2}=[paths{sp,2}, sp];
        paths{r,1}=paths{sp,1}+adj_matrix(sp,r);
        
        [paths,maxim,max_ind] = dfs(r,adj_matrix,visited,paths,maxim, max_ind);
    end
end

if(hasAdj==0)
    paths{sp,2}=[paths{sp,2},sp];
    if(paths{sp,1}>maxim)
        maxim=paths{sp,1};
        max_ind=sp;
    end
end


end



% function [paths, maxim] = dfs( sp, adj_matrix, visited, paths, maxim )
% %UNTITLED6 Summary of this function goes here
% %   Detailed explanation goes here
%
% n = size(adj_matrix,1);
% visited(sp)=1;
% hasAdj=0;
%
% for r=1:n
%     if ((adj_matrix(sp,r)~=0) && (visited(r)==0))
%         paths{r,2}=strcat(paths{sp,2},int2str(sp));
%         paths{r,1}=paths{sp,1}+adj_matrix(sp,r);
%
%         [paths,maxim] = dfs(r,adj_matrix,visited,paths,maxim);
%     end
% end
%
% if(hasAdj==0)
%     paths{sp,2}=strcat(paths{sp,2},int2str(sp));
%     if(paths{sp,1}>maxim)
%         maxim=paths{sp,1};
%     end
% end
%
% end

