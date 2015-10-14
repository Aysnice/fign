function [ ep, bw_skel_o ] = simplify_skeleton( DT, bw_skel_o, bw_bound, bp, ep )
%transform double endpoints at the end to a single endpoint 


ep_bp=cell(1,size(bp,1));
ep_paths=cell(1,size(ep,1));

isBranch=0;
ends_ind=1;

bw_skel=bw_skel_o;

while size(ep,1)>=ends_ind
    
    i=ep(ends_ind,1);
    j=ep(ends_ind,2);
    
    while (isBranch~=1)
        %TODO: when i=1, or j=1, or i=size, or y=size
        ep_paths{1,ends_ind}=[ep_paths{1,ends_ind}; [i,j]];
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

clear isBranch ends_ind node i j I J i_new j_new ij_ind bw_skel

ind_to_delete=[];
ind_to_add=[];

for i_b=1:size(ep_bp,2)
    
    if(size(ep_bp{i_b},2)>=2)
        ends=[ep(ep_bp{i_b},1) ep(ep_bp{i_b},2)];
        e_ind = find_ep4bp( bp(i_b,:), DT(bp(i_b,1),bp(i_b,2)), ends);
        
        if(size(e_ind,2)==2)
            ind_to_delete=[ind_to_delete ep_bp{i_b}];
            
            for iii=1:size(ep_paths{1,ep_bp{i_b}(1,1)})
                iix=ep_paths{1,ep_bp{i_b}(1,1)}(iii,1);
                iiy=ep_paths{1,ep_bp{i_b}(1,1)}(iii,2);
                bw_skel_o(iix,iiy)=0;
            end
            
            for iii=1:size(ep_paths{1,ep_bp{i_b}(1,2)})
                iix=ep_paths{1,ep_bp{i_b}(1,2)}(iii,1);
                iiy=ep_paths{1,ep_bp{i_b}(1,2)}(iii,2);
                bw_skel_o(iix,iiy)=0;
            end
            
%             figure
%             imshow(bw_skel_o),hold on
            
            ep_paths(1,ep_bp{i_b})={0};
            
            new_end_x=round((ends(e_ind(1,1),1)+ends(e_ind(1,2),1))/2);
            new_end_y=round((ends(e_ind(1,1),2)+ends(e_ind(1,2),2))/2);
            
%             plot(new_end_y,new_end_x,'*y', 'LineWidth',5),hold on

            [new_x, new_y] = line_from_2p( bp(i_b,1), bp(i_b,2), new_end_x, new_end_y, bw_skel_o);
            [new_x, new_y] = bresenham(new_x(1,1), new_y(1,1), new_x(1,size(new_x,2)), new_y(1,size(new_y,2))); %we need to rasterize line such that no gaps will be presented

            new_x=[new_x; new_x-1; new_x]; % for the case when line goes through diagonal pixels without crossing. we make it thicker
            new_y=[new_y; new_y; new_y];
            ind_neg=find(new_x<1);
            new_x(ind_neg)=[]; new_y(ind_neg)=[]; new_y=round(new_y);
            
            ind_pos=find(new_x>size(bw_skel_o,1));
            new_x(ind_pos)=[]; new_y(ind_pos)=[]; new_y=round(new_y);
            
%             plot(new_y,new_x,'*g', 'LineWidth',5),hold on
            
            
            indices=sub2ind(size(bw_skel_o),new_x,new_y);
            bw_res=zeros(size(bw_skel_o,1),size(bw_skel_o,2));
            bw_res(indices)=1;
             
            bw_res = immultiply(bw_res,bw_bound);
            
            inters_ind=find(bw_res==1);
        
            [inters_x, inters_y]=ind2sub(size(bw_skel_o),inters_ind);
        
            %plot(inters_y, inters_x,'*b', 'LineWidth',5)
            
            inters_sub=[inters_x inters_y];
            dist=zeros(1,size(inters_sub,1));
        
            for ii=1:size(inters_sub,1)
                dist(ii)=pdist2([bp(i_b,1), bp(i_b,2)],[ inters_sub(ii,1) inters_sub(ii,2)]);
            end
        
            real_int=median(find(dist==min(dist)));
            [new_x, new_y] = bresenham(inters_x(real_int), inters_y(real_int), bp(i_b,1), bp(i_b,2)); %we need to rasterize line such that no gaps will be presented
        
            indices=sub2ind(size(bw_skel_o),new_x,new_y);
            bw_skel_o(indices)=1;
            
            ind_to_add=[ind_to_add; inters_x(real_int), inters_y(real_int)];
        end
    end
end

ep(ind_to_delete,:)=[];
ep=cat(1,ep,ind_to_add);

end
