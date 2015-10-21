function [ellipse_level] = compute_covering_ellipses( local_max_ind,local_min_ind, DT, msp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ellipse_level=[];
%DTy=max(DT);

for i=1:1:size(local_min_ind,1)-1
    ind = find((local_max_ind>local_min_ind(i) & local_max_ind<local_min_ind(i+1)));
    
    if(size(ind,1)==0)
        for w=local_min_ind(i):1:local_min_ind(i+1)
            b=DT(round(w));
            a=2;

            x_=round(w);
            y_=0;
            
            ellipse_level=[ellipse_level ; a b x_ y_];
        end
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

