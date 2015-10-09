Im=imread('/home/aysylu/Desktop/ellipses/batch1/000063B.TIF');
H=fspecial('gaussian',21,21); 
Im_e = imfilter(Im,H,'replicate');
Im_e=edge(Im_e,'Canny', 0.6, 4);
%Im_e=bwmorph(Im_e,'remove');

se = strel('disk',30);
Im_e = imfill(Im_e,'holes');
figure; imshow(Im_e);