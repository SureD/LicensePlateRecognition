function [p, k, k_switch] = locver(I_and,height)
 %   定位垂直方向的区域
 %   输入： I_and: Scw method 处理后的 and 矩阵
 %          height: 图片的高度
 %   输出： p：垂直方向的坐标位置 类型：元胞数组
 %         k： 区域数量 
 %         k_switch 定位成功与否的标志
   conv_window = [3 3 3 3 3];
   %conv_window = [2 2 2 2];
   I_proj = sum(I_and');
% 卷积扩大系数以便运算
   I_proj = conv2(I_proj,conv_window);
   %I_mask = I_and.*imagegray_cell{1};
   %figure,imshow(I_mask);
   %figure,plot(I_proj)
% 定位处理
   if I_proj(1)>0 
       I_proj = [0,I_proj];
   end
   I_proj = double((I_proj>5));
   figure, plot(I_proj);
   point_pro = find(((I_proj(1:end-1)-I_proj(2:end))~=0));
   len_h = length(point_pro) / 2;
   h = height;
%  进行垂直方向的定位
   k = 1;
   k_switch = 0 ; %若找不到可行区域，则换图片重新进行定位
   for i = 1:len_h
       if ((point_pro(2*i) - point_pro(2*i-1))/h < 0.02)||((point_pro(2*i) - point_pro(2*i-1))/h > 0.15)
           continue
       else 
           p{k}=[point_pro(2*i-1),point_pro(2*i)] ;
           k = k + 1;
           k_switch = 1;
       end
   end
   k = k - 1;
%    image_gray = cell(1,k);
%    if k_switch == 1
%        for i = 1 : k
%            image_gray{i}=[imagegray_cell{1}(p{i}(1):p{i}(2),:)];
%            figure, imshow(image_gray{i});
%        end
%    end
end