function [ellipse_level] = compute_covering_ellipses( local_max_ind,local_min_ind, DT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ellipse_level=[];
%DTy=max(DT);
step=1;


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
        if (i+1<=numel(local_max_ind))
            for w=local_max_ind(i):step:local_max_ind(i+1)
                
                b=max(DT(:, round(w)));
                a=0;
                
                ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
                ind_o=median(ind_o);
                [y_ x_]=ind2sub(size(DT),ind_o);
                
                ellipse_level=[ellipse_level ; a b round(w) y_];
            end
            
        else
            [wi,he]=find(DT(:)==1);
            
            for w=local_max_ind(i):step:max(he)
                
                b=max(DT(:, round(w)));
                a=0;
                
                ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
                ind_o=median(ind_o);
                [y_ x_]=ind2sub(size(DT),ind_o);
                
                ellipse_level=[ellipse_level ; a b round(w) y_];
            end
            
        end
        
    elseif(~isempty(ind_after) && ~isempty(ind_before))
        
        if (i==1 && i==numel(local_max_ind))
            ind_before=max(ind_before);
            ind_after=min(ind_after);
            b=max(DT(:,local_max_ind(i)));
            
            x0=local_max_ind(i);
            x1=local_min_ind(ind_before);
            y1=max(DT(:,local_min_ind(ind_before)));
            
            a1=sqrt( (x1-x0)^2/(1-(y1/b)^2));
            
            x2=local_min_ind(ind_after);
            y2=max(DT(:,local_min_ind(ind_after)));
            
            a2=sqrt( (x2-x0)^2/(1-(y2/b)^2));
            
            a=min(a1,a2);
            
        elseif (i==1)
            ind_before=max(ind_before);
%             d1=abs(local_max_ind(i)-local_min_ind(ind_before));
%             a=d1;
            
            b=max(DT(:,local_max_ind(i)));
            
            x0=local_max_ind(i);
            x1=local_min_ind(ind_before);
            y1=max(DT(:,local_min_ind(ind_before)));
            
            a=sqrt( (x1-x0)^2/(1-(y1/b)^2));
            
        elseif (i==numel(local_max_ind))
            ind_after=min(ind_after);
%             d2=abs(local_max_ind(i)-local_min_ind(ind_after));
%             a=d2;
            b=max(DT(:,local_max_ind(i)));
            
            x0=local_max_ind(i);
            x2=local_min_ind(ind_after);
            y2=max(DT(:,local_min_ind(ind_after)));
            
            a=sqrt( (x2-x0)^2/(1-(y2/b)^2));
            
        else
            ind_before=max(ind_before);
            ind_after=min(ind_after);
            %
            %             d1=abs(local_max_ind(i)-local_min_ind(ind_before));
            %             d2=abs(local_max_ind(i)-local_min_ind(ind_after));
            %
            %             a=min(d1,d2);
            
            b=max(DT(:,local_max_ind(i)));
            
            x0=local_max_ind(i);
            x1=local_min_ind(ind_before);
            y1=max(DT(:,local_min_ind(ind_before)));
            
            a1=sqrt( (x1-x0)^2/(1-(y1/b)^2));
            
            x2=local_min_ind(ind_after);
            y2=max(DT(:,local_min_ind(ind_after)));
            
            a2=sqrt( (x2-x0)^2/(1-(y2/b)^2));
            
            a=min(a1,a2);
            
        end
        
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
        
    elseif(isempty(ind_after) && ~isempty(ind_before))
            ind_before=max(ind_before);
%             d1=abs(local_max_ind(i)-local_min_ind(ind_before));
%             a=d1;
            b=max(DT(:,local_max_ind(i)));
            
            x0=local_max_ind(i);
            x1=local_min_ind(ind_before);
            y1=max(DT(:,local_min_ind(ind_before)));
            
            a=sqrt( (x1-x0)^2/(1-(y1/b)^2));
        
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
        for w=local_max_ind(i):step:local_max_ind(i+1)
            b=max(DT(:, round(w)));
            a=0;
            
            ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b round(w) y_];
        end
        
    else
        ind_after=min(ind_after);
        
        x2=local_min_ind(ind_after);
            y2=max(DT(:,local_min_ind(ind_after)));
            
            a=sqrt( (x2-x0)^2/(1-(y2/b)^2));
            
        %a=abs(local_max_ind(i)-local_min_ind(ind_after));
        b=max(DT(:,round(local_max_ind(i))));
        ind_o=find(DT(:,round(local_max_ind(i)))==max(DT(:,round(local_max_ind(i)))) );
        ind_o=median(ind_o);
        [y_ x_]=ind2sub(size(DT),ind_o);
        
        ellipse_level=[ellipse_level ; a b round(local_max_ind(i)) y_];
        
    end
end



for i=1:1:size(local_min_ind,1)-1
    ind = find((local_max_ind>local_min_ind(i) & local_max_ind<local_min_ind(i+1)));
    
    if(size(ind,1)==0)
        for w=local_min_ind(i):step:local_min_ind(i+1)
            b=max(DT(:, round(w)));
            a=0;
            
            ind_o=find(DT(:,round(w))==max(DT(:,round(w))) );
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b round(w) y_];
        end
    end
    
end

end

