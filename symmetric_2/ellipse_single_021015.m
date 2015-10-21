close all; clear all;
%66 61 72 73 80 81
%----------------------------------------------------------
%-------------CREATE AN ELLIPSE 70----------------------------
%----------------------------------------------------------
a = 55;
c = 5;
alpha = 0;%3*pi/4; %in degree

%bw=create_ellipse(a,c,alpha);
% bw=imread('C:\Users\aysylu\Desktop\ellipses\circle.TIF');
% bw=imread('C:\Users\aysylu\Desktop\DATA\binary_batch1\000097B_b.TIF');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame3_bw_female.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame3_bw_male.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame6_bw_female.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame6_bw_male.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame8_bw_male.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame9_bw_female.jpg');
% bw=imread('C:\Users\aysylu\Desktop\DATA\worm_shapes_normalized\vid4_frame9_bw_male2.jpg');
%  bw=imread('/home/aysylu/Desktop/images/blumnot.png');
bw=imread('/home/aysylu/Desktop/images/binary_batch1/000092B_b.TIF'); 
bw=im2bw(bw);
% figure 
% imshow(bw)
clear a c alpha
%----------------------------------------------------------
%-------------PCA------------------------------------------
%----------------------------------------------------------

% as a preprocessing to pca - connected components can be implemented
% or distance transform with rules for distinguishing of different objects
% figure
% imshow(bw)

[bw_crop, Rot]=crop_with_pca(bw);
% bw_crop=bw;

%----------------------------------------------------------
%-------------DISTANCE TRANSFORM---------------------------
%----------------------------------------------------------
% bw_crop=imfill(bw_crop,'holes');
DT = bwdist(~bw_crop,'euclidean');
% 
figure
subimage(mat2gray(DT)),title('city block')
hold on, imcontour(DT)

DT = bwdist(~bw_crop,'cityblock');

DTy=max(DT); %for columns
DTx=max(DT,[],2); %for rows

y_axis=1:size(bw_crop,2); %for ploting columns 

difDTy=(diff(smooth(DTy,0.1,'lowess')));%diff(DTy);
difdifDTy=(diff(difDTy));

%%WATERSHED----------------------
 D = -DT;
 D(~bw_crop) = -Inf;
 
 L = watershed(D); 
 rgb = label2rgb(L,'jet',[.5 .5 .5]);
 figure, imshow(rgb,'InitialMagnification','fit')
 title('Watershed transform of D')
%%-------------------------------

figure
plot(abs(difdifDTy)), hold on

% rrrr=abs(difdifDTy);
% for rr=1:size(rrrr,2)
%     rrrr(rr)=(rrrr(rr)-min(rrrr))/(max(rrrr)-min(rrrr));
% end
% 
% for rr=1:size(rrrr,1)
%     y_axis_rrrr(rr)=(y_axis(rr)-min(y_axis))/(size(rrrr,1)-min(y_axis));
% end
% 
% figure
% plot(y_axis_rrrr,rrrr),hold on
% axis equal

[ local_min_ind, local_max_ind, pseudo_local_maxima, pseudo_local_minima] = find_local_extremum( DTy );
[ max_ind, min_ind ] = find_positive_curvature( DTy );

figure

subplot(411),
topAxs = gca;
photoAxsRatio = get(topAxs,'PlotBoxAspectRatio');
imshow(bw_crop), hold on
axis on; 

subplot(412),plot(y_axis, DTy,'LineWidth',3), hold on
plot(round(local_max_ind),DTy(round(local_max_ind)),'r*'), hold on
plot(round(local_min_ind),DTy(round(local_min_ind)),'g*'), hold on
plot(pseudo_local_maxima,DTy(round(pseudo_local_maxima)),'b*'), hold on
botAxs = gca;
botAxsRatio = photoAxsRatio;
botAxsRatio(2) = photoAxsRatio(2)/3.52    % NOTE: not exactly 3...
set(botAxs,'PlotBoxAspectRatio', botAxsRatio)
xlabel('x-coordinate')
ylabel('maximum of DT')
axis([0 max(y_axis) -max(DTy)-10 max(DTy)+10])

subplot(413), plot(difDTy)%(deltadifDTy)
xlabel('x-coordinate')
ylabel('first derivative of DT')
botAxs = gca;
botAxsRatio = photoAxsRatio;
botAxsRatio(2) = photoAxsRatio(2)/3.52;    % NOTE: not exactly 3...
set(botAxs,'PlotBoxAspectRatio', botAxsRatio)
% axis([0 max(y_axis) -1.3 1.3])


subplot(414), plot((difdifDTy)), hold on 
plot(round(max_ind),difdifDTy(round(max_ind)),'r*'), hold on
plot(round(min_ind),difdifDTy(round(min_ind)),'g*'), hold on
% plot(mean_value, '-r'),%(deltadifDTy)
% plot(median_value, '-g')%(deltadifDTy)
botAxs = gca;
botAxsRatio = photoAxsRatio;
botAxsRatio(2) = photoAxsRatio(2)/3.52;    % NOTE: not exactly 3...
set(botAxs,'PlotBoxAspectRatio', botAxsRatio)
xlabel('x-coordinate')
ylabel('second derivative of DT')
%axis([0 max(y_axis) 0 0.1])

% 
% rrrr=abs(difdifDTy);
% for rr=1:size(rrrr,2)
%     rrrr(rr)=(rrrr(rr)-min(rrrr))/(max(rrrr)-min(rrrr));
% end
% 
% for rr=1:size(rrrr,1)
%     y_axis_rrrr(rr)=(y_axis(rr)-min(y_axis))/(size(rrrr,1)-min(y_axis));
% end
% 
% figure
% plot(y_axis_rrrr,rrrr),
% axis equal





%----------------------------------------------------------
%-------------SILHOUETTE CENTRE COORDINATES----------------
%----------------------------------------------------------
props = regionprops(bw_crop);
O_e=props.Centroid;

clear props

%----------------------------------------------------------
%-------------COMPUTE ELLIPSES' PARAMETERS-----------------
%----------------------------------------------------------

% level 0 - just cover
a = (find(DTy ~= 0,1,'last')-find(DTy ~= 0,1,'first'))/2;
b = max(DTy);
ellipse_level_0=[a b O_e(1) O_e(2)];

% level 1 - only extrema
ellipse_level_1=compute_covering_ellipses( local_max_ind,local_min_ind, DT );

% level 2 - extrema + pseudo
local_min_ind = [local_min_ind; pseudo_local_minima];
local_max_ind = [local_max_ind; pseudo_local_maxima];

local_max_ind = sort(local_max_ind);
local_min_ind = sort(local_min_ind);

ellipse_level_2=compute_covering_ellipses( local_max_ind,local_min_ind, DT );

% ellipse_level_0 = optimize_level( ellipse_level_0,bw_crop);
% ellipse_level_1 = optimize_level( ellipse_level_1,bw_crop);
% ellipse_level_2 = optimize_level( ellipse_level_2,bw_crop);
%----------------------------------------------------------
%-------------COMPUTE ROMBUS EDGE--------------------------
%----------------------------------------------------------
figure
%imshow(bw),title('Euclidean'), hold on
imshow(bw_crop),hold on


plot_ellipse_level(bw_crop, ellipse_level_0, O_e, 'r', 2);
hold on

plot_ellipse_level(bw_crop, ellipse_level_1, O_e, 'g', 2);
hold on

plot_ellipse_level(bw_crop, ellipse_level_2, O_e, 'b', 2);

% plot(O_e(1),O_e(2), 'r*'), hold off