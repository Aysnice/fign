function [bw] = create_ellipse( a, c, alpha )
% a - major axis
% c - focal distance
% alpha - rotation angle

%----------------------------------------------------------
%-------------CREATE ELLIPSE-------------------------------
%----------------------------------------------------------

% Given a,c,alpha
X_ellipse=zeros(200,1); Y_ellipse=zeros(200,1);

b=sqrt(a^2-c^2);
%position of focal points
F1x=c;  F1y=0;
F2x=-c; F2y=0;

%compute x,y,x1,y1
t=0;

while t<2*pi
    tmpx=a*cos(t);
    tmpy=b*sin(t);
    
    tmpx1=(tmpx*cos(alpha)+tmpy*sin(alpha))+1.2*a;
    tmpy1=(-tmpx*sin(alpha)+tmpy*cos(alpha))+1.2*a;
    
    i=int64(t/(0.01*pi)) + 1;
    
    X_ellipse(i)=tmpx1;
    Y_ellipse(i)=tmpy1;
    
    t=t+0.01*pi;
end

    F1x1=(F1x*cos(alpha)+F1y*sin(alpha))+1.2*a;
F1y1=(-F1x*sin(alpha)+F1y*cos(alpha))+1.2*a;
    F2x1=(F2x*cos(alpha)+F2y*sin(alpha))+1.2*a;
F2y1=(-F2x*sin(alpha)+F2y*cos(alpha))+1.2*a;

bw=poly2mask(X_ellipse,Y_ellipse,3*a,3*a);

clear t tmpx tmpy tmpx1 tmpy1 X_ellipse Y_ellipse F1x F1y F2x F2y 

end

