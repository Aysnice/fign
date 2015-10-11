function [ ep, bw_skel ] = simplify_skeleton( DT, bw_skel, bp, ep )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ep_bp=cell(1,size(bp,1));

isBranch=0;
ends_ind=1;


while size(ep,1)>=ends_ind
    
    i=ep(ends_ind,1);
    j=ep(ends_ind,2);
    
    while (isBranch~=1)
        %TODO: when i=1, or j=1, or i=size, or y=size
        bw_skel(i,j)=0;
        
        % check border values for i and j
        if(i==1)
            i_s=i;
            i_e=i+1;
        elseif(i==size(bw_skel,1))
            i_e=i;
            i_s=i-1;
        else
            i_s=i-1;
            i_e=i+1;
        end
        
        if (j==1)
            j_s=j;
            j_e=j+1;
        elseif(j==size(bw_skel,2))
            j_s=j-1;
            j_e=j;
        else
            j_s=j-1;
            j_e=j+1;
        end
        
        I=i_s:1:i_e;
        J=j_s:1:j_e;
        
        [I,J] = meshgrid(I, J);
        ij_ind=sub2ind(size(bw_skel),I,J);
        neigh=bw_skel(ij_ind);
        
        ij_ind=find(neigh==1);
        
        i_new=I(ij_ind);
        j_new=J(ij_ind);
        
        isBranch = ismember([i_new,j_new], bp,'rows');
        
        if (isempty(i_new) && isempty(j_new))
            isBranch=0;
            break;
        elseif sum(isBranch)==0
            isBranch=0;
            
            if(size(i_new,1)>1)
                i=i_new(1);
                j=j_new(1);
            else
                i=i_new;
                j=j_new;
            end
        else
            ind=find(isBranch==1);
            
            if(size(ind,1)>1)
                i=i_new(ind(1));
                j=j_new(ind(1));
            else
                i=i_new(ind);
                j=j_new(ind);
            end
            
            node= bp(:,1)==i & bp(:,2)==j;
            ep_bp{1,node}=[ep_bp{1,node} ends_ind];
            
            
            isBranch=1;
        end
    end
    isBranch=0;
    ends_ind=ends_ind+1;
    
end

ind_to_delete=[];
ind_to_add=[];

for i_b=1:size(ep_bp,2)
    
    if(size(ep_bp{i_b},2)>=2)
        ends=[ep(ep_bp{i_b},1) ep(ep_bp{i_b},2)];
        e_ind = find_ep4bp( bp(i_b,:), DT(bp(i_b,1),bp(i_b,2)), ends);
        
        if(size(e_ind,2)==2)
            ind_to_delete=[ind_to_delete ep_bp{i_b}];
            new_end_x=round((ends(e_ind(1,1),1)+ends(e_ind(1,2),1))/2);
            new_end_y=round((ends(e_ind(1,1),2)+ends(e_ind(1,2),2))/2);
            ind_to_add=[ind_to_add; new_end_x new_end_y];
            
            plot(new_end_y,new_end_x,'*y', 'LineWidth',5),hold on
            
            % Ax+By+C=0
            % A=y2-y1
            % B=x2-x1
            % C=x1y2 - x2y1
%             
%             if (bp(i_b,1)==new_end_x)
%                 if(new_end_x-1 < size(bw_skel,1)-new_end_x)
%                     new_y=1:bp(i_b,2);
%                 else
%                     new_y=bp(i_b,2):size(bw_skel,1);
%                 end
%                                
%                 new_x=repmat(new_end_x,[1,size(new_y,2)]);
%                 
%             elseif(bp(i_b,2)==new_end_y)
%                 
%                 if(new_end_y-1 < size(bw_skel,2)-new_end_y)
%                     new_x=1:bp(i_b,1);
%                 else
%                     new_x=bp(i_b,1):size(bw_skel,2);
%                 end
%                               
%                 new_y=repmat(new_end_y,[1,size(new_x,2)]);
%             else
%                 A=bp(i_b,2)-new_end_y;
%                 B=bp(i_b,1)-new_end_x;
%                 
%                 if(A>B)
%                     if(bp(i_b,2)<new_end_y)
%                         new_y = bp(i_b,2):size(bw_skel,1);
%                     else
%                         new_y = 1:bp(i_b,2); 
%                     end
%                 
%                     new_x=new_end_x+(B/A)*(new_y-new_end_y);
%                     
%                 else
%                     if(bp(i_b,1)<new_end_x)
%                         new_x = bp(i_b,1):size(bw_skel,2);
%                     else
%                         new_x = 1:bp(i_b,1); 
%                     end
%                 
%                     new_y=new_end_y+(A/B)*(new_x-new_end_x);
%                 end
%             end
%             
            [new_x, new_y] = line_from_2p( bp(i_b,1), bp(i_b,2), new_end_x, new_end_y, bw_skel);
            [new_x, new_y]=bresenham(new_x(1,1), new_y(1,1), new_x(1,size(new_x,2)), new_y(1,size(new_y,2))); %we need to rasterize line such that no gaps will be presented
        
            indices=sub2ind(size(bw_skel),new_x,new_y);
            bw_skel(indices)=1;
            
            
            
        end
    end
end

ep(ind_to_delete,:)=[];
ep=cat(1,ep,ind_to_add);

end



%
% ind_to_delete=[];
% ind_to_add=[];
%
% % deleting branching endings
% for i_b=1:1:size(branches,1)
%
%     e_ind = find_ep4bp( branches(i_b,:), DT(branches(i_b,1),branches(i_b,2)), ends )
%     if(size(e_ind,2)==2)
%         ind_to_delete=[ind_to_delete, e_ind];
%         new_end_x=(ends(e_ind(1,1),1)+ends(e_ind(1,2),1))/2;
%         new_end_y=(ends(e_ind(1,1),2)+ends(e_ind(1,2),2))/2;
%         ind_to_add=[ind_to_add; new_end_x new_end_y];
%         plot(new_end_y, new_end_x, '*y','LineWidth',5), hold on
%     end
% end

