Files = dir(strcat('C:\Users\Administrator\Desktop\Worknote\Plate_image\*.bmp'));
k_xunhuan= length(Files);
for i_xunhuan=1:k_xunhuan
pn=['C:\Users\Administrator\Desktop\Worknote\Plate_image\'];
fn=[Files(i_xunhuan).name];
path=[pn fn];
I_orig=imread(path);
I_gray=mat2gray(I_orig);
I_bw=sauvola(I_gray,[16 27],0.10);
% figure
% subplot(121);imshow(I_orig);
% subplot(122);imshow(~I_bw);
imwrite(I_bw,['Plate_image\',fn]);
end