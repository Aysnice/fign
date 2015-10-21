function [ imax, imin ] = find_positive_curvature( DTy )
%FIND_POSITIVE_CURVATURE Summary of this function goes here
%   Detailed explanation goes here

dim=1;
% difDTy=diff(DTy)';
difDTy = (diff(smooth(DTy,0.1,'lowess')));
difdifDTy = diff(difDTy)*1000;
temp = diff(sign(difDTy),1,dim);

pks=findpeaks(difdifDTy);
[xmax,imax,xmin,imin] = extrema((difdifDTy));
%  0 if signs were the same
% -2 if it went from pos to neg
%  2 if it went from neg to pos
% -1 if it went from pos to 0
%  1 if it went from neg to 0

max_ind = find (temp == -2  | temp == -1);
min_ind = find (temp ==  2  | temp == 1);


end

