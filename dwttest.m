        close all ; clear all ; clc;
        [fn,pn,fi] = uigetfile('E:\车牌图片\山西长治白天\*.jpg','选择图片');
        tic
        path = [pn fn];%提取路径
        I_orig = imread([pn fn]);%读入图像
        [height,width] = size(I_orig);
%       针对山西长治的图片的裁剪%
        I_orig = I_orig(80:height-20,:,:);        
        I_gray = rgb2gray(I_orig);
        figure(1);imshow(I_gray);title('原始图像');%显示原始图像
%         [cA1,cH1,cV1,cD1] = dwt2(I_gray,'haar');
%         A1 = upcoef2('a', cA1,'haar',1);
%         H1 = upcoef2('h', cH1,'haar',1);
%         V1 = upcoef2('v', cV1,'haar',1);
%         D1 = upcoef2('d', cD1,'haar',1);
%         figure,
%         a = uint8(wcodemat(A1,192)); 
%         subplot(221); imshow(a);
%         title('近似图像');
%         b = uint8(wcodemat(H1,192));
%         subplot(222); imshow(b);
%         title('水平');
%         c = uint8(wcodemat(V1,192));
%         subplot(223); imshow(c);
%         title('垂直');
%         d = uint8(wcodemat(D1,192));
%         subplot(224); imshow(d);
%         title('对角线');
%         e = sum(b');
%         figure, plot(e);
%         H = fspecial('gaussian');
%         I = imfilter(e,H);
%         figure, plot(I);
       cengshu = 2;
       [C S] = wavedec2(I_gray,cengshu,'haar') ;
%        [H D V] = detco
       A1 = wrcoef2('a',C,S,'haar',cengshu);
       H1 = wrcoef2('h',C,S,'haar',cengshu);
       V1 = wrcoef2('v',C,S,'haar',cengshu);
       D1 = wrcoef2('d',C,S,'haar',cengshu);
        figure,
        a = uint8(wcodemat(A1,192)); 
        subplot(221); imshow(a);
        title('近似图像');
        b = uint8(wcodemat(H1,192));
        subplot(222); imshow(b);
        title('水平');
        c = uint8(wcodemat(V1,192));
        subplot(223); imshow(c);
        title('垂直');
        d = uint8(wcodemat(D1,192));
        subplot(224); imshow(d);
        title('对角线');
        e = sum(b');
        figure, plot(e);
        H = fspecial('gaussian');
        I = imfilter(e,H);
        figure, plot(I);
%         m = mean(I);
%         f = I - m ;
%         ss = double (f>0);
%         figure, plot(ss)
%         g = im2bw(b,graythresh(b));
%  %        g = sauvola(b,[3 3]);
%         figure, imshow(g)
%         kk = I_gray.*uint8(g);
%         figure, imshow(kk);
%         kkk = edge(kk,'sobel')
%         figure,imshow(kkk);
        [ca1 cd1] = dwt(I,'haar');
        subplot(311); plot(I);
        subplot(312); plot(ca1);
        subplot(313); plot(cd1);
        
       
       
       
        