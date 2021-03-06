function [ local_min_ind, local_max_ind, pseudo_local_maxima, pseudo_local_minima] = find_local_extremum( DTy )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pseudo_local_minima = [];
pseudo_local_maxima = [];
borders = [find(DTy ~= 0,1,'first'),find(DTy ~= 0,1,'last')];

dim=1;
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
%---------------------------------------------------------------------
%-check the picks in second derivative--------------------------------
%---------------------------------------------------------------------

difdifDTy=(diff(difDTy)); % second derivative
absdifdifDTy = abs(difdifDTy); % absolute value of the second derivative

median_value = median(absdifdifDTy); % median deviation of values
mean_value = mean(difdifDTy); % mean deviation of values
max_value=max(absdifdifDTy); % max deviation of values

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
    figure
    plot(difDTy), hold on
    
    frags=[];
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
        
        frags=[frags, ind_];
        
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
        
        frags=[frags, ind_];
        
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
        plot(X,Y,'r','LineWidth',1),hold on
        plot(O2(1),O2(2),'b*'),hold on
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
    
    pseudo_local_minima=find_pseudo_local_minima(pseudo_local_maxima,local_max_ind,local_min_ind,'border');%'intersection'
    pseudo_local_maxima=pseudo_local_maxima';
    
    if(~isempty(borders))
        pseudo_local_minima(pseudo_local_minima<borders(1) | pseudo_local_minima>borders(2))=[];

        pseudo_local_maxima(pseudo_local_maxima<borders(1) | pseudo_local_maxima>borders(2))=[];
    end
    
    %     local_min_ind = [local_min_ind; pseudo_local_minima];
    %     local_max_ind = [local_max_ind; pseudo_local_maxima'];
    
    
    %%%tochka peregiba
    
    figure
    plot((difdifDTy)), hold on
    
    
    %     for f=1:size(frags,2)
    %
    %         if (f==1)
    %             difdifDTy(1:frags(1,f),1)=0;
    %         elseif(mod(f,2)==0 && f~=size(frags,2))
    %             difdifDTy(frags(1,f):frags(1,f+1),1)=0;
    %         elseif(f==size(frags,2))
    %             difdifDTy(frags(1,f):size(frags,2),1)=0;
    %         else
    %             continue;
    %         end
    %     end
    %     clear frags f
    %
    [xmax,imax,xmin,imin] = extrema((difdifDTy));
    
    thres=max(xmax)/10;
    f=find(abs(xmax)<thres);
    xmax(f)=[];
    imax(f)=[];
    
    thres=max(abs(xmin))/10;
    f=find(abs(xmin)<thres);
    xmin(f)=[]; %xmin=abs(xmin);
    imin(f)=[];
    
    r=find(xmax<0);
    imax_neg=imax(r); xmax_neg=abs(xmax(r));
    imax(r)=[]; xmax(r)=[];
    imax_pos=imax; xmax_pos=xmax;
    
    r=find(xmin>0);
    imin_pos=imin(r); xmin_pos=xmin(r);
    imin(r)=[]; xmin(r)=[];
    imin_neg=imin; xmin_neg=abs(xmin);
    
    if(~isempty(imax_pos))
        maxi=[imax_pos xmax_pos];
        maxi=sortrows(maxi,1);
        imax_pos=maxi(:,1);
        xmax_pos=maxi(:,2);
    end
    
    if(~isempty(imax_neg))
        maxi=[imax_neg xmax_neg];
        maxi=sortrows(maxi,1);
        imax_neg=maxi(:,1);
        xmax_neg=maxi(:,2);
    end
    
    if(~isempty(imin_pos))
        mini=[imin_pos xmin_pos];
        mini=sortrows(mini,1);
        imin_pos=mini(:,1);
        xmin_pos=mini(:,2);
    end
    
    if(~isempty(imin_neg))
        mini=[imin_neg xmin_neg];
        mini=sortrows(mini,1);
        imin_neg=mini(:,1);
        xmin_neg=mini(:,2);
    end
    
    figure
    plot(difdifDTy),hold on
    
    %
    for f=1:size(imax_pos,1)-1
        
        ind=find(imin_neg>imax_pos(f) & imin_neg<imax_pos(f+1));
        
        if(size(ind,1)>1)
            for l=1:size(ind,1)-1
                ind2=find(imax_neg>imin_neg(l) & imax_neg<imin_neg(l+1));
                if(isempty(ind2))
                    ind=[];
                    break;
                end
            end
            
        end
        
        
        if(~isempty(ind))
            
            thres1=max(xmax_pos(f),  max(xmin_neg(ind)))/min(xmax_pos(f),  max(xmin_neg(ind)));
            thres2=max(xmax_pos(f+1),max(xmin_neg(ind)))/min(xmax_pos(f+1),max(xmin_neg(ind)));
            
            thres=max(thres1,thres2);
            
            
            if(thres<4)
                
                ind=find(local_max_ind>imax_pos(f) & local_max_ind<imax_pos(f+1));
                if(~isempty(ind))
                    local_max_ind(ind,:)=[];
                end
                
                ind=find(pseudo_local_maxima>imax_pos(f) & pseudo_local_maxima<imax_pos(f+1));
                if(~isempty(ind))
                    pseudo_local_maxima(ind,:)=[];
                end
            end
            
        end
    end
    
    for f=1:size(imin,1)-1
        
        ind=find(imax_pos>imin_neg(f) & imax_pos<imin_neg(f+1));
        
        if(size(ind,1)>1)
            for l=1:size(ind,1)-1
                ind2=find(imin_pos>imax_pos(l) & imin_pos<imax_pos(l+1));
                if(isempty(ind2))
                    ind=[];
                    break;
                end
            end
            
        end
        
        
        if(~isempty(ind))
            
            thres1=max(xmin_neg(f),  max(xmax_pos(ind)))/min(xmin_neg(f),  max(xmax_pos(ind)));
            thres2=max(xmin_neg(f+1),max(xmax_pos(ind)))/min(xmin_neg(f+1),max(xmax_pos(ind)));
            
            thres=max(thres1,thres2);
            %
            
            if(thres<4)
                ind=find(local_min_ind>imin_neg(f) & local_min_ind<imin_neg(f+1));
                if(~isempty(ind))
                    local_min_ind(ind,:)=[];
                end
                
                ind=find(pseudo_local_minima>imin_neg(f) & pseudo_local_minima<imin_neg(f+1));
                if(~isempty(ind))
                    pseudo_local_minima(ind,:)=[];
                end
            end
        end
    end
    %
    %
    
    plot(round(imax_pos),difdifDTy(round(imax_pos)),'r*'), hold on
    plot(round(imin_neg),difdifDTy(round(imin_neg)),'g*'), hold on
    
end

local_max_ind = sort(local_max_ind);
local_min_ind = sort(local_min_ind);
%
% local_max_ind=round(local_max_ind);
% local_min_ind=round(local_min_ind);


end

