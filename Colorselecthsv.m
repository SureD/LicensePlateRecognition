function ratio=Colorselecthsv(Imagedata)
myI=Imagedata;
%index=p{1};
%myI=I_orig(index(1)-2:index(2),index(3):index(4),:);
BLUE=0;
[Y1,X1,Z1]=size(myI);
pratio=X1/Y1;
for i=1:Y1
    for j=1:X1
            if(((myI(i,j,1)<=0.70)&&(myI(i,j,1)>=0.55))&&((myI(i,j,2)<=1)&&(myI(i,j,2)>=0.35))&&... 
                    ((myI(i,j,3)<=1) &&(myI(i,j,3)>=0.35)))
            %if((CP_color(m,n,1)<=30)&&((CP_color(m,n,2)<=62)&&(CP_color(m,n,2)>=51))&&((CP_color(m,n,3)<=142)&&(CP_color(m,n,3)>=119))) 
% 蓝色RGB的灰度范围
               BLUE= BLUE+1;     % 蓝色象素点统计          
           end  
    end       
end
COLOR_ratio=BLUE/(X1*Y1);
if COLOR_ratio>0
    ratio=pratio;
else
    ratio=0;
end