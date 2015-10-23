function [ pseudo_local_minima ] = find_pseudo_local_minima(pseudo_extremum,local_max_ind,local_min_ind,param)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

pseudo_local_minima=[];
d=0;

if (strcmp(param,'border')==1)
    
    for i=1:1:size(local_min_ind,1)-1
        ind_p = find((pseudo_extremum>local_min_ind(i) & pseudo_extremum<local_min_ind(i+1)));
        ind_e = find((local_max_ind>local_min_ind(i)   & local_max_ind<local_min_ind(i+1)));
        
        if(size(ind_e,1)~=0)
            delete_flag=[];
            v=[];
            for j=1:1:size(ind_p,2)
                %                 if(abs(local_max_ind(ind_e) - pseudo_extremum(ind_p(j))) <10)
                %                     delete_flag=[delete_flag; j];
                %
                %                 else
                if(local_max_ind(ind_e) > pseudo_extremum(ind_p(j)))
                    d1=abs(pseudo_extremum(ind_p(j))-local_min_ind(i));
                    d2=abs(pseudo_extremum(ind_p(j))-local_max_ind(ind_e));
                    if (d1>d2)
                        d=d2/2;
                    else
                        d=d1;
                    end
                    v=pseudo_extremum(ind_p(j))+d;
                else
                    d1=abs(pseudo_extremum(ind_p(j))-local_min_ind(i+1));
                    d2=abs(pseudo_extremum(ind_p(j))-local_max_ind(ind_e));
                    if (d1>d2)
                        d=d2/2;
                    else
                        d=d1;
                    end
                    v= pseudo_extremum(ind_p(j))-d;
                end
                pseudo_local_minima=[pseudo_local_minima; v];
            end
            
            if(size(delete_flag,1)>0)
                pseudo_extremum(ind_p(delete_flag))=[];
            end
            
        else
            d1=abs(pseudo_extremum(ind_p)-local_min_ind(i));
            d2=abs(pseudo_extremum(ind_p)-local_min_ind(i+1));
            
            for j=1:1:size(ind_p,2)
                
                if(d1(j)>d2(j))
                    pseudo_local_minima=[pseudo_local_minima; pseudo_extremum(ind_p(j))+d1(j)];
                else
                    pseudo_local_minima=[pseudo_local_minima; pseudo_extremum(ind_p(j))-d2(j)];
                end
            end
        end
    end
    
    
    
elseif (strcmp(param,'intersection')==1)
    
    for i=1:1:size(local_min_ind,1)-1
        ind_p = find((pseudo_extremum>local_min_ind(i) & pseudo_extremum<local_min_ind(i+1)));
        ind_e = find((local_max_ind>local_min_ind(i)   & local_max_ind<local_min_ind(i+1)));
        
        if(size(ind_e,1)~=0)
            delete_flag=[];
            v=[];
            for j=1:1:size(ind_p,2)
                %                 if(abs(local_max_ind(ind_e) - pseudo_extremum(ind_p(j))) <10)
                %                     delete_flag=[delete_flag; j];
                %
                %                 else
                if(local_max_ind(ind_e) > pseudo_extremum(ind_p(j)))
                    v=pseudo_extremum(ind_p(j))+0.01;
                else
                    v=pseudo_extremum(ind_p(j))-0.01;
                end
                pseudo_local_minima=[pseudo_local_minima; v];
            end
            
            if(size(delete_flag,1)>0)
                for i=1:1:size(delete_flag)
                    pseudo_extremum(ind_p(delete_flag(i)))=[];
                end
            end
            
        else
            d1=abs(pseudo_extremum(ind_p)-local_min_ind(i));
            d2=abs(pseudo_extremum(ind_p)-local_min_ind(i+1));
            
            for j=1:1:size(ind_p,2)
                
                if(d1(j)>d2(j))
                    pseudo_local_minima=[pseudo_local_minima; pseudo_extremum(ind_p(j))+0.01];
                else
                    pseudo_local_minima=[pseudo_local_minima; pseudo_extremum(ind_p(j))-0.01];
                end
            end
        end
    end
    
end

end

