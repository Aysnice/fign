function [ local_min_ind, local_max_ind, pseudo_local_maxima, pseudo_local_minima] = find_local_extremum( DTy )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pseudo_local_minima = [];
pseudo_local_maxima = [];
borders = [find(DTy ~= 0,1,'first'),find(DTy ~= 0,1,'last')];

dim=1;
% difDTy=diff(DTy)';
difDTy=(diff(smooth(DTy,0.05,'lowess')));
temp = diff(sign(difDTy),1,dim);

%  0 if signs were the same
% -2 if it went from pos to neg
%  2 if it went from neg to pos
% -1 if it went from pos to 0
%  1 if it went from neg to 0

local_max_ind = find (temp == -2  | temp == -1);
local_min_ind = find (temp ==  2  | temp == 1);

if(~isempty(borders))
    local_min_ind(local_min_ind<borders(1) | local_min_ind>borders(2))=[];
    local_min_ind=[borders(1), local_min_ind', borders(2)]';
end
%---------------------------------------------------------------------
%-check when there are two local maxima one by one``------------------
%---------------------------------------------------------------------

% we are interested in case when there is no local minimum between two
% local maxima. Particularly, the first local maximum was detected as
% a change from pos to 0, whereas the second - as a change from 0 to neg.
i=1;
while i<=size(local_max_ind,1)-1
    ind = find((local_min_ind>local_max_ind(i) & local_min_ind<local_max_ind(i+1)));
    if (size(ind,1)==0)
        if (temp(local_max_ind(i))==-1 && temp(local_max_ind(i+1))==-1)                 %TODO!!! Should go from pos to 0, then from 0 to neg, but matlab says twice from pos to 0
            local_max_ind(i)=(local_max_ind(i+1)-local_max_ind(i))/2+local_max_ind(i);
            local_max_ind(i+1)=[];
            i=i-1;
        end
    end
    i=i+1;
end

clear temp i ind

%---------------------------------------------------------------------
%-check the picks in second derivative--------------------------------
%---------------------------------------------------------------------

difdifDTy=(diff(difDTy)); % second derivative
absdifdifDTy = abs(difdifDTy); % absolute value of the second derivative

median_value = median(absdifdifDTy); % median deviation of values
mean_value = mean(difdifDTy); % mean deviation of values
max_value=max(absdifdifDTy); % max deviation of values

%TODO median_value=0, tochka peregiba?
if(max_value/median_value>8)
    
    %find the peaks which are higher than the half of the highest peak
    ind=find(absdifdifDTy>0.2*max_value);
    
    element_array = [];
    indices_array = [];
    i=1;
    while i<=size(ind,1)
        
        ind_i=ind(i);
 
        element_array = [element_array, absdifdifDTy(ind_i)];
        indices_array = [indices_array, ind_i];
        
        if(i==size(ind,1))
            v=indices_array(element_array==max(element_array) );
            pseudo_local_maxima = [pseudo_local_maxima, v];
            
        else
            ind_j=ind(i+1);
            
            if(ind_j-ind_i>1 )
                v=indices_array(element_array==max(element_array));
                pseudo_local_maxima = [pseudo_local_maxima, v];
                element_array=[];
                indices_array=[];
            end
            
        end
        
        i=i+1;
    end
    clear v
    
    %------------------------------------------
    %----------check the dirac mu--------------
    %------------------------------------------
    delete_flag=[];
    for i=1:1:size(pseudo_local_maxima,2)
        
        ind_i=pseudo_local_maxima(1,i);
        
        a_est=absdifdifDTy(ind_i)/2;
        dist_min=1000000;
        dist_tmp=0;
        
        if(ind_i>1)
            for h=ind_i-1:-1:1
                dist_tmp=abs(absdifdifDTy(h)-a_est);
                if(dist_tmp<dist_min)
                    dist_min=dist_tmp;
                    ind_=h;
                else
                    break;
                end
            end
        else
            ind_=ind_i;
        end

        q=(2*a_est-absdifdifDTy(ind_))/(ind_i-ind_);
        p=2*a_est-ind_i*q;
        
        b1_new=abs(ind_i-(a_est-p)/q);
        
        dist_min=1000000;
        
        if(ind_i<size(DTy,2))
            for h=ind_i+1:1:size(absdifdifDTy,1)
                dist_tmp=abs(absdifdifDTy(h)-a_est);
                if(dist_tmp<dist_min)
                    dist_min=dist_tmp;
                    ind_=h;
                else
                    break;
                end
            end
        else
            ind_=ind_i;
        end

        q=(2*a_est-absdifdifDTy(ind_))/(ind_i-ind_);
        p=2*a_est-ind_i*q;
        
        b2_new=abs(ind_i-(a_est-p)/q);
        
        a_1=100*a_est;
        b_est=min(b1_new,b2_new);

        e_=((abs(b_est^2-a_1^2))^0.5/b_est^2);
        
        if (e_<0.8)
            delete_flag=[delete_flag i];
        end
            O2=[ind_i,a_est];
            [X,Y] = compute_ellipse(b_est,a_est,O2);%, Rot);
%             plot(X,Y,'r','LineWidth',1),hold on
%             plot(O2(1),O2(2),'b*'),hold on
            hold on
    end
    hold off
    pseudo_local_maxima(delete_flag)=[];
    %------------------------------------------
    %----------check the dirac mu--------------
    %------------------------------------------
    
    
    
    
    %---------------------------------------------------------------------
    %-check the picks in second derivative--------------------------------
    %---------------------------------------------------------------------
    
%     pseudo_local_minima=find_pseudo_local_minima(pseudo_local_maxima,local_max_ind,local_min_ind,'border');%'intersection'
%     pseudo_local_maxima=pseudo_local_maxima';
%     local_min_ind = [local_min_ind; pseudo_local_minima];
%     local_max_ind = [local_max_ind; pseudo_local_maxima'];
     
end

local_max_ind = sort(local_max_ind);
local_min_ind = sort(local_min_ind);
% 
% local_max_ind=round(local_max_ind);
% local_min_ind=round(local_min_ind);


end

