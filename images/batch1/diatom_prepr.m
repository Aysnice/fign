addr='/home/aysylu/Desktop/ellipses/batch1/';
im_num='000101B';
addr2='/home/aysylu/Desktop/ellipses/binary_batch1/';

Im=imread(strcat(addr,im_num,'.TIF'));
H=fspecial('gaussian',10,10); 
%Im_e = imfilter(Im,H,'replicate');
%figure; imshow(Im_e);
Im_e=edge(Im,'Canny', 0.3, 3);
%Im_e=bwmorph(Im_e,'remove');
Im_e = imfill(Im_e,'holes');

[L,num]=bwlabel(Im_e,4);
labels=[];
if (num>1)
    for i=1:num
        l=size(find(L==i),1);
        labels(i)=l;
    end
[m,ind]=max(labels);
L(L~=ind)=0;
end
Im_e=logical(L);

imwrite(Im_e, strcat(addr2,im_num,'_b.TIF'));

figure; imshow(Im_e);
