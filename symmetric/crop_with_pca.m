function [ bw_crop, Rot, O ] = crop_with_pca( bw )
%   bw - original binary image
%   bw_crop - cropped binary image with a normalized silhouette according
%   to pca

%first, we take from the binary image only points corresponding to the
%region (pixel value equals 1)
ind=find(bw>0);
[sy_o,sx_o]=ind2sub(size(bw),ind);

%for future correspondence we compute the position of the centroid
% O_ = regionprops(logical(bw),'centroid');
% O = [floor(O_.Centroid(1)) floor(O_.Centroid(2))];
O=[0,9];
%for the points of the region we then compute axes of major and minor
%deviation using standard pca
[Rot, score, latent]=pca([sx_o sy_o]);

% Rot = [cos(alpha) sin(alpha); -sin(alpha) cos(alpha)];

% knowing the rotational transformation matrix Rot from pca, we rotate the 
% binary region back by multiplying with inverse rotational matrix  
G=inv(Rot)*[sx_o sy_o]';

% compute number of columns and rows of the region 
columns=round(max(G(1,:))-min(G(1,:)));
rows =round(max(G(2,:))-min(G(2,:)));

% compute the distances to shift the region to the center of cropped image
dx= columns/2;
dy= rows/2;

G=bsxfun(@minus,G,[min(G(1,:)); min(G(2,:))]);
G=bsxfun(@plus,G,[dx; dy]);

bw_pred=zeros(2*rows +4 ,2*columns+4);

x_normal=round(G(1,:));
y_normal=round(G(2,:));

indices = sub2ind([2*rows+4 ,2*columns+4],y_normal, x_normal);
bw_pred(indices) = 1;

% delete the holes inside the region if exist 
bw_pred = imfill(bw_pred,'holes');

%crop the image to the region
bw_crop = imcrop(bw_pred, [min(x_normal)-2 min(y_normal)-2 (max(x_normal)-min(x_normal))+4 (max(y_normal)-min(y_normal))+4]);
% 
% clear bw_pred indices x_normal y_normal height width alpha G dx dy ind DT O_ rows columns sx_o sy_o score latent

end

