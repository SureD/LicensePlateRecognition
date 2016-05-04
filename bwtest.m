% %         BW = imread('text.png');
% %         L  = bwlabel(BW,8) ;
% %         s  = regionprops(BW, 'BoundingBox');
% %         BoundingBox = cat(1, s.BoundingBox);
% %         imshow(BW);
% %         hold on
% %         k = size(s);
% %         for i = 1 : k
% %              rectangle('Position', [BoundingBox(i,1) BoundingBox(i,2) BoundingBox(i,3) BoundingBox(i,4)])
% %         end
% %         %hold on
% %         %plot(centroids(:,1), centroids(:,2), 'b*')
% %         %hold off
clc;close all;clear all;
Img=imread('cameraman.tif');
if ndims(Img)==3
    I=rgb2gray(Img);
else
    I=Img;
end
I=im2bw(I,graythresh(I));
[m,n]=size(I);
imshow(I);title('cameraman.tif');
txt=get(gca,'Title');
set(txt,'fontsize',16);
L=bwlabel(I);
stats=regionprops(L,'BoundingBox','Image');
% set(gcf,'color','w');
% set(gca,'units','pixels','Visible','off');
% q=get(gca,'position');
% q(1)=0;%…Ë÷√◊Û±ﬂæ‡¿Î÷µŒ™¡„
% q(2)=0;%…Ë÷√”“±ﬂæ‡¿Î÷µŒ™¡„
% set(gca,'position',q);
for i=1:length(stats)
    hold on;
    rectangle('position',stats(i).BoundingBox,'edgecolor','g','linewidth',1);
%     temp = stats(i).Centroid;
%     plot(temp(1),temp(2),'r.');
%     drawnow;
end     
        