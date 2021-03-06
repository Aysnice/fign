function res = apply_algorithm( bw, hf, number_of_vertices )
% bw=imread('C:\Users\aysylu\Desktop\binary_batch1\000085B_b.tif');
% bw=imread('C:\Users\aysylu\Desktop\ellipses\horse.png');
% bw=imread('C:\Users\aysylu\Desktop\dataset1\root004_8.png');
% bw=imread('C:\Users\aysylu\Desktop\worms\vid4_frame9_bw.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\vital brains\notSmooth_cortex_scaled_2D-Annotation43_C.png');

% bw=imread('/home/aysylu/Desktop/images/rects.png');
% bw=imread('/home/aysylu/Desktop/images/dataset1/root005_20.png');
% bw=imread('/home/aysylu/Desktop/images/binary_batch1/000065B_b.TIF');
% bw=imread('/home/aysylu/Desktop/images/worm_shapes_normalized/vid4_frame3_bw_female.jpg');
% bw=imread('/home/aysylu/Desktop/images/worms/vid4_frame9_bw.jpg');

global bw
bw=im2bw(bw);
bw_bound = bwmorph(bw,'remove');
%distance transformin

DT = bwdist(~bw,'euclidean');
% figure
% subimage(mat2gray(DT))%,title('euclidean')
% hold on, imcontour(DT)

%classical matlab skeletonization
bw_skel = bwmorph(bw,'skel',Inf);
%classical matlab endpoint detection
endpoints=bwmorph(bw_skel,'endpoints');
[ex ey]=find(endpoints==1);
%classical matlab branchpoint detection
branchpoints=bwmorph(bw_skel,'branchpoints');
[bx by]=find(branchpoints==1);

% figure
% imshow(bw_skel), hold on
% plot(ey, ex, '*g','LineWidth',5), hold on
% plot(by, bx, '*r','LineWidth',5), hold off

clear endpoints branchpoints;

ends=[ex ey];
branches=[bx by];
% figure
% imshow(bw_skel),hold on

[ ends, bw_skel ] = simplify_skeleton( DT, bw_skel,bw_bound, branches, ends );

%classical matlab endpoint detection
ends=bwmorph(bw_skel,'endpoints');
[ex, ey]=find(ends==1);
%classical matlab branchpoint detection
branches=bwmorph(bw_skel,'branchpoints');
[bx, by]=find(branches==1);

ends=[ex ey];
branches=[bx by];

% ex=ends(:,1);
% ey=ends(:,2);

axes(hf.axes3)
%figure
imshow(bw_skel), hold on
plot(ey, ex, '*g','LineWidth',5), hold on
plot(by, bx, '*r','LineWidth',5), hold off


ends=unique(ends,'rows');
branches=unique(branches,'rows');

end_is_branch=ismember(branches, ends,'rows');
if(sum(end_is_branch)>0)
    end_is_branch=find(end_is_branch==1);
    branches(end_is_branch,:)=[];
    bx=branches(:,1);
    by=branches(:,2);
end

list_of_nodes=[ends; branches];
adjacency_matrix = zeros(size(list_of_nodes,1),size(list_of_nodes,1));

bw_skel_copy=bw_skel;
ends_ind=1;
path_array={};
isBranch=0;

while size(ends,1)>=ends_ind
    
    length=0;
    i=ends(ends_ind,1);
    j=ends(ends_ind,2);
    
    node_1=find(list_of_nodes(:,1)==i & list_of_nodes(:,2)==j);
    p=path_segment(node_1);
        
    path_array{end+1}=p;
    path_array{end}=path_array{end}.add_point([i,j]);
    
    while (isBranch~=1)
        bw_skel_copy(i,j)=0;
        
        % check border values for i and j
        if(i==1)
            i_s=i;
            i_e=i+1;
        elseif(i==size(bw_skel_copy,1))
            i_e=i;
            i_s=i-1;
        else
            i_s=i-1;
            i_e=i+1;
        end
        
        if (j==1)
            j_s=j;
            j_e=j+1;
        elseif(j==size(bw_skel_copy,2))
            j_s=j-1;
            j_e=j;
        else
            j_s=j-1;
            j_e=j+1;
        end
        
        I=i_s:1:i_e;
        J=j_s:1:j_e;
        
        [I,J] = meshgrid(I, J);
        ij_ind=sub2ind(size(bw_skel_copy),I,J);
        neigh=bw_skel_copy(ij_ind);
        
        ij_ind=find(neigh==1);
        
        i_new=I(ij_ind);
        j_new=J(ij_ind);
        
        isBranch = ismember([i_new,j_new],list_of_nodes,'rows');
        
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
            
            path_array{end}=path_array{end}.add_point([i,j]);
            length=length+1;
        else
            ind=find(isBranch==1);
        
            
            if(size(ind,1)>1)
                i=i_new(ind(1));
                j=j_new(ind(1));
            else
                i=i_new(ind);
                j=j_new(ind);
            end
            path_array{end}=path_array{end}.add_point([i,j]);
            length=length+1;
            isBranch=1;
        end
        
    end
    
    if (isBranch==1)
        node_2=find(list_of_nodes(:,1)==i & list_of_nodes(:,2)==j);
        path_array{end}.end_p=node_2;
        isBranch = 0;
        
        adjacency_matrix(node_1,node_2)=length;
        adjacency_matrix(node_2,node_1)=length;
    else
        path_array{end}={};
        path_array=path_array(~cellfun('isempty',path_array));
    end
    
    ends_ind=ends_ind+1;
    
    if (size(ends,1)<ends_ind)
        if (sum(sum(bw_skel_copy))>0)
            %matlab classics for endpoint and branchpoint detection
            ends=bwmorph(bw_skel_copy,'endpoints');
            [tmpx tmpy]=find(ends==1);
            ends=[tmpx tmpy];
            
            branches=bwmorph(bw_skel_copy,'branchpoints');
            [tmpx tmpy]=find(branches==1);
            branches=[tmpx tmpy];
            
            isEnd = ismember([ends(:,1),ends(:,2)],list_of_nodes,'rows');
            ind_end_e =find(isEnd==1);
                
            if(~isempty(ind_end_e))
                ends=ends(ind_end_e,:);
            else
                
                isEnd = ismember([branches(:,1),branches(:,2)],list_of_nodes,'rows');
                ind_end_b=find(isEnd==1);
                
                if(~isempty(ind_end_b))
                    ind_end_min=find(ind_end_b(:,1)==min(ind_end_b(:,1)));
                    ends=[branches(ind_end_b(ind_end_min),1) branches(ind_end_b(ind_end_min),2)];
                else
                    list_of_nodes=[list_of_nodes; ends];
                    new_x=path_array{end}.path_x(1,size(path_array{end}.path_x,2));
                    new_y=path_array{end}.path_y(1,size(path_array{end}.path_x,2));
                    
                    ends=[ends;[new_x,new_y]];
                end
            end
%             
%             figure
%             imshow(bw_skel_copy),hold on
%             plot(branches(:,2),branches(:,1), '*r', 'LineWidth', 5),hold on
%             plot(ends(:,2),ends(:,1), '*g', 'LineWidth', 5),hold on
%             
            ends_ind=1;
            clear tmpx tmpy isEnd ind_end
        end
    end
    
end
path_array=path_array(~cellfun('isempty',path_array));

clear ends branches ends_ind isBranch node_1 node_2 bw_skel_copy i j length tmp_x tmp_y neigh i_new j_new ind p ind

ends=[ex ey];
branches=[bx by];
main_stamm={};
tmp_main_stamm=[1,1,1];

ends_indices=1:size(ends,1);

tmp_adjacency_matrix=adjacency_matrix;

while size(ends_indices,2)>0
    [tmp_main_stamm] = find_path( ends_indices, tmp_adjacency_matrix);
    ind=find(tmp_main_stamm<=size(ends,1));
    
    ends_indices(ismember(ends_indices,tmp_main_stamm(ind)))=[];
    
    for ii=1:size(tmp_main_stamm,2)-1
        tmp_adjacency_matrix(tmp_main_stamm(ii),tmp_main_stamm(ii+1))=0;
        tmp_adjacency_matrix(tmp_main_stamm(ii+1),tmp_main_stamm(ii))=0;
    end
    
    if size(tmp_main_stamm,2)>number_of_vertices
        main_stamm{end+1}=tmp_main_stamm;
    end
end

clear ends_indices tmp_adjacency_matrix tmp_main_stamm ii ind

main_stamm_paths={};

for ms=1:size(main_stamm,2)
    
    path_x=[];
    path_y=[];
    
    for p=1:size(main_stamm{ms},2)-1
        s=main_stamm{ms}(p);
        e=main_stamm{ms}(p+1);
        
        vec_e = cellfun( @(path_segment) path_segment.end_p, path_array, 'uni', true);
        vec_s = cellfun( @(path_segment) path_segment.start_p, path_array, 'uni', true);
        
        vec=[vec_s' vec_e'];
        ind_f = find(vec(:,1) == s & vec(:,2) == e);
        ind_b = find(vec(:,2) == s & vec(:,1) == e);
        
        if(isempty(ind_f))
            path_x=[path_x fliplr(path_array{ind_b}.path_x)];
            path_y=[path_y fliplr(path_array{ind_b}.path_y)];
        else
            path_x=[path_x (path_array{ind_f}.path_x)];
            path_y=[path_y (path_array{ind_f}.path_y)];
        end
        
    end
    
    main_stamm_paths{ms}=[path_x' path_y'];
end


clear p ms path_x path_y ind_f ind_b vec vec_s vec_e s e

% figure
% imshow(bw_skel), hold on
ii=1;
set(gca,'FontSize',24)
ColOrd = get(gca,'ColorOrder');

% Determine the number of colors in the matrix
[m,n] = size(ColOrd);
%
% hold on,
latitude={};
normal={};
nb=15;

for ms=1:size(main_stamm_paths,2)
    
        % Color Order Matrix
        ColRow = rem(ii,m);
        if ColRow == 0
            ColRow = m;
        end
    
        % Get the color
        Col = ColOrd(ColRow,:);
    
% figure
% imshow(bw_skel), hold on 
    X=main_stamm_paths{ms}(:,1);
    Y=main_stamm_paths{ms}(:,2);
    %
    
%     plot(Y,X,'Color',Col,'LineWidth',3);
         ii=ii+1;
    
    bw_bound = bwmorph(bw,'remove');
    if(size(X,1)<nb)
        nb=5;
    end
    [latitude{ms},normal{ms}] = find_latitude(X,Y,bw_bound,nb);
end

clear ii ColOrd m n ms ColRow X Y Col
ellipse_level=[];
for ms=1:size(main_stamm_paths,2)
    y_axis=1:size(latitude{ms},2);
    DT = smooth(latitude{ms},0.05,'lowess');
    
    [ local_min_ind, local_max_ind, pseudo_local_maxima, pseudo_local_minima] = find_local_extremum( DT );
    
%         local_min_ind = [local_min_ind; pseudo_local_minima'];
%         local_max_ind = [local_max_ind; pseudo_local_maxima];
    
    local_max_ind = sort(local_max_ind);
    local_min_ind = sort(local_min_ind);
    
    params=compute_covering_ellipses( local_max_ind,local_min_ind, DT',main_stamm_paths{ms});
    tmp=repmat(ms,[size(params,1),1]);
    params(:,5)=tmp;
    ellipse_level=[ellipse_level; params];
%     
%     figure
%     plot(y_axis, DT,'LineWidth',3),hold on
%     
%     plot(round(local_max_ind),DT(round(local_max_ind)),'r*'), hold on
%     plot(round(local_min_ind),DT(round(local_min_ind)),'g*'), hold on
%     plot(pseudo_local_maxima,DT(round(pseudo_local_maxima)),'b*'), hold on
%     
end


clear y_axis DT local_min_ind local_max_ind pseudo_local_maxima pseudo_local_minima params tmp ms

%figure
axes(hf.axes5)
imshow(bw), hold on
ii=1;
set(gca,'FontSize',24)
ColOrd = get(gca,'ColorOrder');

% Determine the number of colors in the matrix
[m,n] = size(ColOrd);

hold on,

for ie=1:size(ellipse_level,1)
    % Color Order Matrix
    ColRow = rem(ii,m);
    if ColRow == 0
        ColRow = m;
    end
    
    % Get the color
    Col = ColOrd(ColRow,:);
    
    a=ellipse_level(ie,1);
    b=ellipse_level(ie,2);
    ind_center=ellipse_level(ie,3);
    ind_ms=ellipse_level(ie,5);
    O = main_stamm_paths{ind_ms}(ind_center,:);
    
    for x_i=-a:1:a
        ind_norm=ind_center+floor(x_i);
        
        if(ind_norm>size(normal{ind_ms},2) || ind_norm<1)
            continue;
        end
        
        A=normal{ind_ms}(1,ind_norm);
        B=normal{ind_ms}(2,ind_norm);
        
        y_i_neg=-b*(sqrt(1-x_i^2/a^2 ));
        y_i_pos= b*(sqrt(1-x_i^2/a^2 ));
        
        d=pdist2([x_i 0],[x_i y_i_pos]);
        plot(main_stamm_paths{ind_ms}(ind_norm,2),main_stamm_paths{ind_ms}(ind_norm,1),'r'),hold on
        
        %
        %%KAPUSTA BEGINS HERE
        if(B==0)
            x_2=main_stamm_paths{ind_ms}(ind_norm,1);
            y_2=main_stamm_paths{ind_ms}(ind_norm,2);
            
            x=[x_2-d x_2+d];
            y=[y_2 y_2];
            
        elseif(A==0)
            x_2=main_stamm_paths{ind_ms}(ind_norm,1);
            y_2=main_stamm_paths{ind_ms}(ind_norm,2);
            
            x=[x_2 x_2];
            y=[y_2-d y_2+d];
        else
            x_2=main_stamm_paths{ind_ms}(ind_norm,1);
            y_2=main_stamm_paths{ind_ms}(ind_norm,2);
            
            dx=d*cos(atan(-B/A));
            
            x=[x_2-dx, x_2+dx];
            y=[y_2+(B/A)*((x_2-(x_2-dx))),y_2+(B/A)*(x_2-(x_2+dx))];
        end
        plot(y,x,'Color',Col,'LineWidth',2),hold on
    end
    
    ii=ii+1;
    
end
hold off
end

