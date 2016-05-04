function [p, k, k_switch] = waveana(Img,cengshu)
   
% 二维小波变换
       [C, S] = wavedec2(Img,cengshu,'haar') ;
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
       % 投影
        e = sum(b,2);
        figure, plot(e);
       % 高斯滤波
        H = fspecial('gaussian',[5 5],0.8); %参数可修改
        I = imfilter(e,H);
        figure, plot(I);
        value_m = mean(I);
%%%%%%%%%%%%%%%%%%% 一维小波变换  暂定为一层%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [ca1, cd1] = dwt(I,'haar');
        subplot(311); plot(I); title('原波形');
        subplot(312); plot(ca1);title('低频'); % 低频
        subplot(313); plot(cd1);title('高频'); % 高频
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%间断点系数投影%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [height,width] = size(Img);
        len_proj = 35 ;    %长度设置
        len_step = 20 ;    %跳跃步长
        abs_cd = abs(cd1); %求绝对值
        count_a = 4;
        %%%%%%%定义待投影矩阵%%%%%%%%
        l = length(cd1); %系数长度
        h_proj = floor(l/len_step); %求出行数
        mat_w = zeros(h_proj,len_proj); %定义零矩阵
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1 : h_proj
            tempf = i+(i-1)*len_step ;
            tempff = l - tempf; %是否长度不够
            if tempff < len_proj   %剩余数据不够
                mat_w(i,1:tempff) = abs_cd(tempf:tempf+tempff-1);
            else            
                mat_w(i,:) = abs_cd(tempf:tempf+len_proj-1);
            end
        end
        mat_p = sum(mat_w,2);
        figure,plot(mat_p);
        sort_p = sort(-mat_p);
%         temp_m = length(sort_p);
%         temp_m1 = floor(temp_m/2);
        %%%%找出投影值最大的前三组%%%%%%%%%%%%%%%%%%
        temp_p = zeros(1,count_a); %记录最大值
        p = cell(1,count_a);       %记录位置
        for i = 1 :count_a
            temp_p(i) = find(mat_p == abs(sort_p(i)));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for  i = 1 : count_a
            tempy = temp_p(i);
            % 还原为源图像中的坐标
            y1 = max(1,2*(tempy+(tempy-1)*len_step));  
            y2 = min(height,y1+len_proj*2);
            p{i} = [y1,y2];
        end
        clearvars tempy temp_p
        k = count_a;
        k_switch = 1;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%峰值密度检测%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         [v, pos] = findpeaks(I);
% %         % 将低于平均值的波峰删除
% %         pos_a = v>mean(I);
% % %         pos_a = v>0 ;
% %         pos_b = pos(pos_a);
% %         % 差分
% %         diff_a = diff(pos_b);
% %         % 找出区间波峰之间的距离小于10
% %         pos_c = diff_a<10;
% %         pos_d = pos_b(pos_c);
% %         % 分解区间
% %         diff_b = diff(pos_d);
% %         xb = find(diff_b>11); %pos_d的有用（间断点）下标
% %         %pos_t = pos_d(pos_e);
% %         % 获取坐标
% %         len_x = length(xb); %间断点的下标长度
% %         len_d = length(pos_d);
% %         p_t = cell(1,len_x+1);
% %         k = len_x+1;
% %         % 获取区间坐标
% %         for i = 1:len_x+1
% %             if i == 1
% %                 p_t{i} = [pos_d(1),pos_d(xb(i))];
% %                 continue
% %             end
% %             if i == len_x+1
% %                 p_t{i} = [pos_d(xb(i-1)+1),pos_d(len_d)];
% %                 continue
% %             end
% %             p_t{i} = [pos_d(xb(i-1)+1),pos_d(xb(i))];
% %         end
% %         p = p_t;
% %         k_switch = 1 ;
% %         
%%%%%%%%%峰值检测%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         p = cell(1,3);
%         len = size(b);
%         long = floor(len(1)/10)+1;
%         temp = abs(sort(-I));
%         [r,c] = find(I == temp(1));
%         p{1} = [max(r-long,1), r];
%         p{2} = [r,min(r+long, len(1))];
%         p{3} = [max(r-floor(long/2),1), min(r+floor(long/2), len(1))];
%         k_switch = 1;
%         k = 3;
%%%%%%%%%end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%二值化测试%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         Img_mask = double(I>value_m);
% %         %宽高
% %         len = size(b);
% %         temp_mat = ones(1,len(2));
% %         Img_mask = Img_mask*temp_mat;
% %         b_mask = uint8(Img_mask).*b; 
% %         b_bw = im2bw(b_mask,0.2);
% %         figure, imshow(b_bw)
% %         % 数学形态学处理
% %         Image_temp = bwareaopen(b_bw,5);
% %         SE = strel('square',40);
% %         Image_temp = imdilate(Image_temp,SE);
% %         Image_temp = imerode(Image_temp,SE);
% %         figure,imshow(Image_temp)
% %         c_proj = sum(Image_temp,2);
% %         figure, plot(c_proj)
% %         %投影定位
% %         if c_proj(1)>0 
% %            c_proj(1) = 0;
% %         end
% %         c_proj = double((c_proj>10));
% %         figure, plot(c_proj);
% %         point_pro = find(((c_proj(1:end-1)-c_proj(2:end))~=0));
% %         len_h = length(point_pro) / 2;
% %         h = len(1);
% %         %  进行垂直方向的定位
% %         k = 1;
% %         k_switch = 0 ; %若找不到可行区域，则换图片重新进行定位
% %         for i = 1:len_h
% %             if ((point_pro(2*i) - point_pro(2*i-1))/h < 0.02)||((point_pro(2*i) - point_pro(2*i-1))/h > 0.3)
% %                     continue
% %             else 
% %                     p{k}=[point_pro(2*i-1),point_pro(2*i)] ;
% %                     k = k + 1;
% %                     %改变标志位
% %                     k_switch = 1;
% %             end
% %         end
% %         k = k - 1;
% %         if k_switch == 0
% %             p = 0 ;
% %         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
end