function [ latitude, normal ] = find_latitude(X,Y,bw,nb)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

s=size(Y,1);

i_s=(nb-1)/2+1;
i_e=s-i_s+1;
i_step=(nb-1)/2;
%
latitude=zeros(1,s);
normal=zeros(2,s);

figure
imshow(bw)
hold on

for ss=i_s:i_e
    
    s_ind=ss-i_step:ss+i_step;
    s_y=Y(s_ind);
    s_x=X(s_ind);
    
    p = polyfit(s_x,s_y,1);
    
    if(p(1,1)==Inf || p(1,1)==-Inf)
        p = polyfit(s_y,s_x,1);
        t_x = round((polyval(p,s_y)).*100)/100;
        t_y = s_y;
    else
        t_y = round((polyval(p,s_x)).*100)/100;
        t_x = s_x;
    end
    
    
    % Ax+By+C=0
    % A=y2-y1 ; B=x2-x1 ; C=x1*y2-x2*y1 ;
    
    A=t_y(nb,1)-t_y(1,1);
    B=t_x(nb,1)-t_x(1,1);
    
    % due to troubles with polyfit for horizontal / vertical lines
    if(A==0 && B==0)
        p = polyfit(s_y,s_x,1);
        t_x = round((polyval(p,s_y)).*100)/100;
        t_y = s_y;
        
        A=t_y(nb,1)-t_y(1,1);
        B=t_x(nb,1)-t_x(1,1);
    end
    
    
    
    if(ss==i_s || ss==i_e)
        ss_s=1;
        ss_e=i_step+1;
    else
        ss_s=i_step+1;
        ss_e=i_step+1;
    end
    
    for ss_i=ss_s:ss_e
        
        if (ss==i_s)
            real_index=ss_i;
        elseif(ss==i_e)
            real_index=s_ind(ss_i+i_step);
        else
            real_index=ss;
        end
        
        
        if(B==0)
            n_x=1:size(bw,1);
            n_y=t_y(ss_i,1);
        elseif(A==0)
            n_y=1:size(bw,2);
            n_x=repmat(t_x(ss_i,1),[1,size(n_y,2)]);
        else
            n_x=1:size(bw,1);
            n_y=t_y(ss_i,1)+(B/A)*(t_x(ss_i,1)-n_x);
        end
        
        plot (t_y, t_x, 'g','LineWidth',2), hold on
        plot (n_y, n_x, 'b','LineWidth',1), hold on
        plot (s_y, s_x, '*r','LineWidth',2), hold on
        
        ind_neg=find(n_y<1);
        n_x(ind_neg)=[]; n_y(ind_neg)=[]; n_y=round(n_y);
        
        ind_pos=find(n_y>size(bw,2));
        n_x(ind_pos)=[]; n_y(ind_pos)=[]; n_y=round(n_y);
        
        bw_n=zeros(size(bw,1), size(bw,2));
        [n_x n_y]=bresenham(n_x(1,1), n_y(1,1), n_x(1,size(n_x,2)), n_y(1,size(n_y,2))); %we need to rasterize line such that no gaps will be presented
        
        indices=sub2ind(size(bw),n_x,n_y);
        bw_n(indices)=1;
        
        n_x=n_x-1; % for the case when line goes through diagonal pixels without crossing. we make it thicker
        ind_neg=find(n_x<1);
        n_x(ind_neg)=[]; n_y(ind_neg)=[]; n_y=round(n_y);
        indices=sub2ind(size(bw),n_x,n_y);
        bw_n(indices)=1;
        
        %
        bw_res = immultiply(bw,bw_n);
        inters_ind=bwmorph(bw_res,'endpoints');
        [inters_x inters_y]=find(inters_ind==1);
%         inters_ind=find(bw_res==1);
%         
%         [inters_x inters_y]=ind2sub(size(bw),inters_ind);
        plot (inters_y, inters_x, '*y','LineWidth',2), hold on
        inters_sub=[inters_x inters_y];
        dist=zeros(1,size(inters_sub,1));
        
        if(~isempty(inters_sub))
            for ii=1:size(inters_sub,1)
                dist(ii)=pdist2([s_x(ss_i,1) s_y(ss_i,1)],[ inters_sub(ii,1) inters_sub(ii,2)]);
            end
        else
            dist=0;
        end
        
        
        latitude(1,real_index)=min(dist);
        normal(1,real_index)=A;
        normal(2,real_index)=B;
    end
    
    
    clear ind_neg ind_pos bw_n indices inters_sub inters_x inters_y ii
    
end

end



