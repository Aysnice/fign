function res = apply_algorithm( bw, hf, number_vertices )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bw=im2bw(bw);
bw_bound = bwmorph(bw,'remove');
res=1;

axes(hf);
imshow(bw_bound)
resultant_image=bw_bound;

end

