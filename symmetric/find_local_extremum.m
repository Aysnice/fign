function [ local_min_ind, local_max_ind, pseudo_local_maxima, pseudo_local_minima] = find_local_extremum( DTy )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pseudo_local_minima = [];
pseudo_local_maxima = [];
borders = [find(DTy ~= 0,1,'first'),find(DTy ~= 0,1,'last')];

dim=1;
% difDTy=diff(DTy)';
difDTy=(diff(smooth(DTy,0.1,'lowess')));
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
    clear v i
    
%------------------------------------------
    %----------check the dirac mu--------------
    %------------------------------------------
    delete_flag=[];
    
    a_min=min(absdifdifDTy);
    a_max=max(absdifdifDTy);
    
    b_min=1;
    b_max=size(DTy,2);
    
    for i=1:1:size(pseudo_local_maxima,2)
        
        ind_i=pseudo_local_maxima(1,i);
        
        a_est=absdifdifDTy(ind_i)/2;
        dist_min=100000000;
        till_end=0;
        cur=a_est*2;
        
        if(ind_i>1)
            for h=ind_i-1:-1:1
                dist_tmp=abs(abs(absdifdifDTy(h)) - a_est);
                prev=cur;
                cur=abs(absdifdifDTy(h));
                           
                if(cur>a_est || h==ind_i-1)
                    dist_min=dist_tmp;
                    ind_=h;
                else
                    till_end=1;
                    break;
                end
            end
        else
            ind_=ind_i;
        end
        
        if(till_end)
            if(a_est<abs(absdifdifDTy(ind_)))
                x2=ind_;
                y2=abs(absdifdifDTy(x2));
                x3=ind_-1;
                y3=abs(absdifdifDTy(x3));
            elseif(a_est>abs(absdifdifDTy(ind_)))
                x2=ind_+1;
                y2=abs(absdifdifDTy(x2));
                x3=ind_;
                y3=abs(absdifdifDTy(x3));
            else
                x2=ind_;
                y2=0;
                x3=ind_;
                y3=1;
            end
            
            x=x2-(x2-x3)*(y2-a_est)/(y2-y3);
            b1_new=ind_i-x;
        else
            b1_new=0;
        end
        
        
        plot(x,a_est,'r*'),hold on
        
        
        till_end=0;
        dist_min=1000000;
        cur=a_est*2;
        
        if(ind_i<size(DTy,2))
            for h=ind_i+1:1:size(absdifdifDTy,1)
                dist_tmp=abs(abs(absdifdifDTy(h)) - a_est);
                prev=cur;
                cur=abs(absdifdifDTy(h));
                
               
                if(cur>a_est || h==ind_i+1)
                    dist_min=dist_tmp;
                    ind_=h;
                else
                    till_end=1;
                    break;
                end
            end
        else
            ind_=ind_i;
        end
        
        
        if(till_end)
            if(a_est<abs(absdifdifDTy(ind_)))
                x2=ind_;
                y2=abs(absdifdifDTy(x2));
                x3=ind_+1;
                y3=abs(absdifdifDTy(x3));
            elseif(a_est>abs(absdifdifDTy(ind_)))
                x2=ind_-1;
                y2=abs(absdifdifDTy(x2));
                x3=ind_;
                y3=abs(absdifdifDTy(x3));
            else
                x2=ind_;
                y2=0;
                x3=ind_;
                y3=1;
            end
            
            x=x2-(x2-x3)*(y2-a_est)/(y2-y3);
            b2_new=ind_i-x;
        else
            b2_new=0;
        end
        plot(x,a_est,'r*'),hold on
        
%         a_1=(a_est-a_min)/(a_max-a_min);
        mult=1;
        tmp=median_value;
        
        while tmp<1
            mult=mult*10;
            tmp=tmp*10;
        end
        
        
        step=(a_max-a_min)/size(absdifdifDTy,1);
        a_1=a_est*100;%(a_est-a_min)/(a_max-a_min);
        b_est=max(b1_new,b2_new);
        b_1=b_est;%(b_est-b_min)/(b_max-b_min);
        
        
        e_=((abs(a_1^2-b_1^2))^0.5/a_1);
        
        if (e_<0.9 || e_>1.0)
            delete_flag=[delete_flag i];
        end
        O2=[ind_i,a_est];
        [X,Y] = compute_ellipse(b_est,a_est,O2);%, Rot);
        plot(X,Y,'r','LineWidth',1),hold on
        plot(O2(1),O2(2),'b*'),hold on
        hold on
    end
    hold off
    clear cond e_ b_est a_est X Y O2 a_1 b1_new b2_new x x2 y2 x3 y3 till_end ind_ ind_i
    pseudo_local_maxima(delete_flag)=[];
    %------------------------------------------
    %----------check the dirac mu--------------
    %------------------------------------------
    
    %---------------------------------------------------------------------
    %-check the picks in second derivative--------------------------------
    %---------------------------------------------------------------------
    
    pseudo_local_minima=find_pseudo_local_minima(pseudo_local_maxima,local_max_ind,local_min_ind,'border');%'intersection'
    pseudo_local_maxima=pseudo_local_maxima';
    %     local_min_ind = [local_min_ind; pseudo_local_minima];
    %     local_max_ind = [local_max_ind; pseudo_local_maxima'];
    
end

local_max_ind = sort(local_max_ind);
local_min_ind = sort(local_min_ind);
%
% local_max_ind=round(local_max_ind);
% local_min_ind=round(local_min_ind);


end

