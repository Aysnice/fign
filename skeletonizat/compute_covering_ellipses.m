function [ellipse_level] = compute_covering_ellipses( local_max_ind,local_min_ind, DT, msp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ellipse_level=[];
%DTy=max(DT);


for i=1:1:size(local_min_ind,1)-1
    tmp_min=abs(local_min_ind-local_min_ind(i));
    tmp_max=abs(local_max_ind-local_min_ind(i));
    
    step=0;
    ind_2=[];
    
    if(i==1)
        if(tmp_max(1,1)>tmp_min(i+1))
            ind=i+1;
            step=1;
        end
    else
        ind_1 = find(tmp_max<tmp_min(i+1)); 
        
        for tt=1:size(ind_1,1)
            if(ind_1(tt)==1)
                continue;
            else
                ind_2 = [ind_2, find(tmp_max(ind_1(tt)-1,1)>tmp_min(i-1))];
            end
        end
        
        if(sum(ind_2)>0)
            ind = i-1;
            step=-1;
        else
            ind_1 = find(tmp_max<tmp_min(i-1)); 
            
            for tt=1:size(ind_1,1)-1
                 ind_2 = [ind_2, find(tmp_max(ind_1(tt)+1,1)>tmp_min(i+1))];
            end
            
            if(sum(ind_2)>0)
                ind=i+1;
                step=1;
            else
                ind=[];
            end
        end
    end
    
    if(step~=0)
        for w=local_min_ind(i):step:local_min_ind(ind)
            b=DT(round(w));
            a=2;
%             
            x_=round(w);
            y_=1;%msp(round(w),2);
%             ind_o=find(DT(:,round(local_min_ind(i)))==max(DT(:,round(local_min_ind(i)))));
%             ind_o=median(ind_o);
%             [y_, x_]=ind2sub(size(DT),ind_o);
            
            ellipse_level=[ellipse_level ; a b x_ y_];
        end
    else
        continue;
    end
end



for i=1:1:size(local_min_ind,1)-1
    ind = find((local_max_ind>local_min_ind(i) & local_max_ind<local_min_ind(i+1)));
    
    if(size(ind,1)==0)
        continue;
    else
        
        for j=1:1:size(ind,2)
            
            d1=abs(local_max_ind(ind(j))-local_min_ind(i));
            d2=abs(local_max_ind(ind(j))-local_min_ind(i+1));
            
            a=max(d1,d2);
            b=DT(round(local_max_ind(ind(j))));
            
            ind_o=find(DT(:,round(local_max_ind(ind(j))))==max(DT(:,round(local_max_ind(ind(j))))));
            ind_o=median(ind_o);
            [y_ x_]=ind2sub(size(DT),ind_o);

            ellipse_level=[ellipse_level ; a b round(local_max_ind(ind(j))) y_];
        end
    end
end

end

