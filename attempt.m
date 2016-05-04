% s∑®≥¢ ‘
a = sauvola(image_gray{2},[3 3]);
figure,imshow(~a)
 b = bwareaopen(~a,5);
 L=bwlabel(~a,8);
 stats=regionprops(L,'BoundingBox','Image');
for i=1:length(stats)
    hold on;
    rectangle('position',stats(i).BoundingBox,'edgecolor','g','linewidth',1);
%     temp = stats(i).Centroid;
%     plot(temp(1),temp(2),'r.');
%     drawnow;
end     




% ±ﬂ‘µ+≈Ú’Õ∏Ø ¥
 a = edge(image_gray{2},'sobel');
figure,imshow(a)
 b = bwareaopen(a,5);
 SE=strel('square',15);
 b=imdilate(b,SE);
 b=imerode(b,SE);
 L=bwlabel(b,4);
 stats=regionprops(L,'BoundingBox','Image');
for i=1:length(stats)
    hold on;
    rectangle('position',stats(i).BoundingBox,'edgecolor','g','linewidth',1);
%     temp = stats(i).Centroid;
%     plot(temp(1),temp(2),'r.');
%     drawnow;
end     