function [ellipse_level] = compute_covering_ellipses( local_max_ind,local_min_ind, DT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ellipse_level=[];
%DTy=max(DT);
step=5;


for i=1:1:size(local_max_ind,1)
    
    if(i==size(local_max_ind,1))
        max_after=1000000000000000000000000;
    else
        max_after=local_max_ind(i+1)-local_max_ind(i);
    end
    
    
    if(i==1)
        max_before=1000000000000000000000000;
    else
        max_before=local_max_ind(i)-local_max_ind(i-1);
    end
    
    dist2min=abs(local_min_ind-local_max_ind(i));
   
    ind=find(dist2min(:)<max_after);
    
    if(i==size(local_max_ind,1))
        ind_after = local_min_ind(ind)>local_max_ind(i);
    else
        ind_after = local_min_ind(ind)<local_max_ind(i+1) & local_min_ind(ind)>local_max_ind(i);
    end
    
    ind_after =ind(ind_after);
    
    ind=find(dist2min(:)<max_before);
    
        
    
    if(i==1)
        ind_before=find(local_min_ind(ind)<local_max_ind(i));
    else
        ind_before=find(local_min_ind(ind)<local_max_ind(i) & local_min_ind(ind)>local_max_ind(i-1));
    end
    ind_before=ind(ind_before);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if( isempty(ind_after) && isempty(ind_before) )
        
        for w=local_max_ind(i):step:local_max_ind(i+1)
            b=max(DT(:, round(w)));
            a=2;
            
            ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b round(w) y_];
        end
        
        
    elseif(~isempty(ind_after) && ~isempty(ind_before))
        ind_before=max(ind_before);
        ind_after=min(ind_after);
        
        d1=abs(local_max_ind(i)-local_min_ind(ind_before));
        d2=abs(local_max_ind(i)-local_min_ind(ind_after));
        
        a=min(d1,d2);
        
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
        
    elseif(isempty(ind_after) && ~isempty(ind_before))
        
        ind_before=max(ind_before);
        a=abs(local_max_ind(i)-local_min_ind(ind_before));
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
        for w=local_max_ind(i):step:local_max_ind(i+1)
            b=max(DT(:, round(w)));
            a=2;
            
            ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b round(w) y_];
        end
        
    else
        ind_after=min(ind_after);
        
        a=abs(local_max_ind(i)-local_min_ind(ind_after));
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
    end
    
    
    
    
%     
%     if(size(ind2,1)==0)
%         for w=local_max_ind(i):5:local_max_ind(i+1)
%             b=max(DT(:, round(w)));
%             a=2;
%             
%             ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
%             ind_o=median(ind_o);
%             [y_ x_]=ind2sub(size(DT),ind_o);
%             
%             ellipse_level=[ellipse_level ; a b round(w) y_];
%             
%         end
%     else
%         ind2=min(ind2);
%         
%         if(ind2==2)
%             a=abs(local_max_ind(i)-local_min_ind(ind2-1));
%         elseif(ind2==size(local_min_ind,1))
%             a=abs(local_max_ind(i)-local_min_ind(ind2));
%         else
%             d1=abs(local_max_ind(i)-local_min_ind(ind2));
%             d2=abs(local_max_ind(i)-local_min_ind(ind2-1));
%             a=min(d1,d2);
%         end
%         
%         b=max(DT(:,round(local_max_ind(i))));
%         ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
%         ind_o=median(ind_o);
%         [y_ x_]=ind2sub(size(DT),ind_o);
%         
%         ellipse_level=[ellipse_level ; a b round(w) y_];
%         
%         
%     end
end



for i=1:1:size(local_min_ind,1)-1
    ind = find((local_max_ind>local_min_ind(i) & local_max_ind<local_min_ind(i+1)));
    
    if(size(ind,1)==0)
        for w=local_min_ind(i):5:local_min_ind(i+1)
            b=max(DT(:, round(w)));
            a=2;
            
            ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b round(w) y_];
        end
    end    
        
%     else
%         
%         for j=1:1:size(ind,2)
%             
%             d1=abs(local_max_ind(ind(j))-local_min_ind(i));
%             d2=abs(local_max_ind(ind(j))-local_min_ind(i+1));
%             
%             if(i==1)
%                 a=d1;
%             elseif(i+1==size(local_min_ind,1))
%                 a=d2;
%             else
%                 a=min(d1,d2);
%             end
%             b=max(DT(:,round(local_max_ind(ind(j)))));
%             
%             ind_o=find(DT(:,round(local_max_ind(ind(j))))==max(DT(:,round(local_max_ind(ind(j))))));
%             ind_o=median(ind_o);
%             [y_ x_]=ind2sub(size(DT),ind_o);
%             
%             ellipse_level=[ellipse_level ; a b round(local_max_ind(ind(j))) y_];
%         end
%     end
end

end

