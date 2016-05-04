        %车牌定位%%%
        clear;clc;close all
        [fn,pn,fi] = uigetfile('E:\车牌图片\山西长治白天\*.jpg','选择图片');
        tic
        path = [pn fn];%提取路径
        I_orig = imread([pn fn]);%读入图像
        [height,width] = size(I_orig);
%         针对山西长治的图片的裁剪%
        I_orig = I_orig(80:height-20,:,:);
        figure(1);imshow(I_orig);title('原始图像');%显示原始图像
        I_gray = rgb2gray(I_orig);
%         I_gray = medfilt2(I_gray,[5 5]);
        figure(2);imshow(I_gray);
        I_edge_sobel = edge(I_gray,'sobel','horizontal');
%         I_edge_sobel = edge(medfilt2(I_gray,[5 5]),'sobel','horizontal');
        [H,T,R] = hough(I_edge_sobel);
%         控制最短的霍夫检测参数hough_tr
        hough_thr = 0.04;
        P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
        lines = houghlines(I_edge_sobel,T,R,P,'FillGap',75,'MinLength',hough_thr*width);
%         清除变量
        clearvars H T R P hough_thr 
        figure(3), imshow(I_edge_sobel),hold on
        max_len = 0;
        lines_length = length(lines);
        linesdata(1,lines_length) = struct('x',[],'linenorm',[],'abslength',[],'switch',[]);
        for k = 1:lines_length
%         画出检测到的直线
            xy = [lines(k).point1; lines(k).point2];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%         plot beginnings and ends of lines
             plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
             plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%         determine the endpoints of the longest line segment 
            len = norm(lines(k).point1 - lines(k).point2);
            if ( len > max_len)
              max_len = len;
              xy_long = xy;
            end
        
        end
% 转换数据，保留水平方向的直线
    truelines_length = lines_length; %记录水平直线的个数
    for k=1:lines_length
        if abs(abs(lines(k).theta)-90)<30
            linesdata(k).x = min(lines(k).point1,lines(k).point2);
            linesdata(k).linenorm = norm(lines(k).point1 - lines(k).point2);
            linesdata(k).abslength = linesdata(k).x(1,1)+linesdata(k).linenorm;
            linesdata(k).switch = 1;
        else
            linesdata(k).switch = 0;
            linesdata(k).x = 0;
            linesdata(k).linenorm = 0;
            linesdata(k).abslength = 0;
            truelines_length = truelines_length-1;
        end
    end
 % 提出有效区域
    pro = dividedarea(linesdata,lines_length,truelines_length);
    figure(4)
    I_eff_orig = I_orig(:,pro(1).point(1,1):pro(1).length,:);
    imshow(I_eff_orig);
    I_eff_gray = I_gray(:,pro(1).point(1,1):pro(1).length);
    [height,width] = size(I_eff_gray);
% 分割有效区域
    I_eff_orig_up = I_eff_orig(1:pro(1).point(1,2),:,:);
    I_eff_orig_below = I_eff_orig(pro(1).point(1,2):height,1:width,:);
    I_eff_gray_up = I_eff_gray(1:pro(1).point(1,2),:);
    I_eff_gray_below = I_eff_gray(pro(1).point(1,2):height,1:width);
% 存储有效区域，存为两个胞元，并按优先级排序
    imagegray_cell = {I_eff_gray_below I_eff_gray_up}; %灰度图像
    imageorig_cell = {I_eff_orig_below I_eff_orig_up}; %彩色图像
% 测试显示
    imshow(I_eff_gray); hold on
    plot([1 pro(1).length],[pro(1).point(1,2) pro(1).point(1,2)]);
    I_eff_edge_below = edge(I_eff_gray_below,'sobel');
    figure(5)
    imshow(I_eff_edge_below);
    clearvars  width height
% % % 膨胀腐蚀
% %     BW=bwareaopen(I_eff_edge_below,30);SE=strel('square',15);
% %     IM=imdilate(BW,SE);
% %     IM1=imerode(IM,SE);
% %     IM1=bwareaopen(IM1,50);
% %     SE=strel('rectangle',[5,5]);
% %     IM2=imerode(IM1,SE);
% % %     IM2=bwareaopen(IM2,20);
% %     IM3=imdilate(IM2,SE);
% %     figure(6)
% %     imshow(IM3)
%  sauvola binarization
%     I_bw=sauvola(I_eff_gray_below,[10 20],0.1);  %效果不是很好，可以用在字符分割
%     figure(7)
%     imshow(I_bw)
    %%%%%
    %imshow(I_gray(:,pro(1).point(1,1):pro(1).length)); hold on
    %plot(pro(1).point,[pro(1).point(1,1)+pro(1).length pro(1).point(1,2)],'LineWidth',2,'Color','green');
%%%    Scws method 
% [height,width]=size(I_eff_gray_below);
% I_and=zeros(height,width);
% scw_thr=1.1;
% for i=1:height
%     for j=1:width
%        linju=neibor_eight(i,j,I_eff_gray_below);
%        mean_neibor=mean(linju);
%        tempvalue=I_eff_gray_below(i,j);
%        value=mean_neibor/tempvalue;
%        if value>scw_thr
%            I_and(i,j)=1;
%        else
%            I_and(i,j)=0;
%        end
%     end
% end
% I_mask=uint8(I_and).*I_eff_gray_below;
% figure(6)
% imshow(I_mask);
% SE=strel('rectangle',[20,20]);
% I_mask=imdilate(I_mask,SE);
% figure(7)
% imshow(I_mask);
% I_bw_mask=im2bw(I_mask,0.1);
% figure(8)
% imshow(I_bw_mask);
% scw method verison 2.0 优先级开关默认值为0，若定位失败则其转换为1
%%%%%%%%%%%%%%小波测试段%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p, k, k_switch] = waveana(imagegray_cell{1},2);
%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Scw测试段%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if k_switch == 0
   scw_thresh = 1.1;
   I_and = Scw(imagegray_cell{1},scw_thresh,[7 18],[3 3]);
% % %    conv_window=[3 3 3 3 3];
% % %    I_proj = sum(I_and');
% 卷积扩大系数以便运算
% % %    I_proj = conv2(I_proj,conv_window);
   I_mask = I_and.*imagegray_cell{1};
   figure,imshow(I_mask);
%    figure,plot(I_proj)
   [height width] = size(I_eff_gray_below);
   [p, k, k_switch] = locver(I_and,height);
   use = 1;
end
%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% 定位处理
% % %    if I_proj(1)>0 
% % %        I_proj = [0,I_proj];
% % %    end
% % %    I_proj = double((I_proj>5));
% % %    figure, plot(I_proj);
% % %    point_pro = find(((I_proj(1:end-1)-I_proj(2:end))~=0));
% % %    len_h = length(point_pro) / 2;
% % %    h = height;
% % % %  进行垂直方向的定位
% % %    k = 1;
% % %    k_switch = 0 ; %若找不到可行区域，则换图片重新进行定位
% % %    for i = 1:len_h
% % %        if ((point_pro(2*i) - point_pro(2*i-1))/h < 0.02)||((point_pro(2*i) - point_pro(2*i-1))/h > 0.15)
% % %            continue
% % %        else 
% % %            p{k}=[point_pro(2*i-1),point_pro(2*i)] ;
% % %            k = k + 1;
% % %            k_switch = 1;
% % %        end
% % %    end
% % %    k = k - 1;
   temp = 1 ;  % 用于记录备选区域的数量
   if k_switch == 1
       image_gray = cell(1,k);
       image_orig = cell(1,k);
       count_wt = 0;
       % 构建一个连通域分析后选定的一个结构
       sQ =  struct('height',[],'width',[],'center',[1 1],'neibors',[],'isflag',[]);
       for i = 1 : k
           image_gray{i} = imagegray_cell{1}(p{i}(1):p{i}(2),:);  % 存储待选区域
           image_orig{i} = imageorig_cell{1}(p{i}(1):p{i}(2),:,:);
           figure, imshow(image_gray{i});
%%%%%%%%%%%%%区域生长
%            Ia = im2double(image_gray{i});
%            %xa=33; ya=181;
%            Ja = regiongrowing(Ia,0.2); 
%            figure, imshow(Ia+Ja);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % sa法二值化+形态学
%            a=~sauvola(image_gray{i},[8 8]);
%            figure, imshow(a)
%            Image_tempta = bwareaopen(a,15);
%            SE = strel('square',25);
%            Image_tempta = imdilate(Image_tempta,SE);
%            Image_tempta = imerode(Image_tempta,SE);
%            figure,imshow(Image_tempta)
%            % 连通域分析
%%%%%%%%%%%%%%%%%%%%%%%%%%%增加一些预处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %             I_gray = image_gray{i};
% %            [height,width]=size(I_gray);
% %             %%预处理
% %             I_edge=zeros(height,width);
% %             for jj=1:width-1
% %                 I_edge(:,jj)=abs(I_gray(:,jj+1)-I_gray(:,jj));
% %             end
% %             I_edge=(255/(max(max(I_edge))-min(min(I_edge))))*(I_edge-min(min(I_edge)));
% %             figure,imshow(I_edge);
% %             [I_edge,y1]=select(I_edge,height,width);   %%%%%%调用select函数
% %             figure,imshow(I_edge);
% %             BW2 = I_edge;%
% %             %%一些形态学处理
% %             SE=strel('rectangle',[10,10]);
% %             IM2=bwareaopen(BW2,20);
% %             IM2=imdilate(IM2,SE);
% %             IM3=imerode(IM2,SE);
% %             Image_temp=IM3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%边缘检测法9.8%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Image_temp = edge(image_gray{i},'sobel');
%            figure,imshow(Image_temp)
%            % 数学形态学处理
%            Image_temp = bwareaopen(Image_temp,10);
%            SE = strel('square',15);
%            Image_temp = imdilate(Image_temp,SE);
%            Image_temp = imerode(Image_temp,SE);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            % 相与
% %            Image_temp = Image_tempta .* Image_tempt ;
%             figure,imshow(Image_temp)
%            % 连通域标记 采用4连通
%            L = bwlabel(Image_temp,4);
%            % 参数反馈
%            stats = regionprops(logical(L),'BoundingBox','Image');
%            % 作图
%                 for ii = 1 : length(stats)
%                       hold on;
%                       [h,w] = size(stats(ii).Image);
%                       temp_s = h * w;
%                       %temp_a = sum(sum(stats(ii).Image));
%                       if temp_s > 2000 && (w / h) > 2 && (w / h) < 7   %  constraints
%                             rectangle('position',stats(ii).BoundingBox,'edgecolor','g','linewidth',2);  % 测试，还未存储
%                             axis_temp = ceil(stats(ii).BoundingBox);  % 获取坐标
%                             % -1是为了不越界
%                             Image_tgrayplate{temp} = image_gray{i}(axis_temp(2):axis_temp(2)+axis_temp(4)-1,axis_temp(1):axis_temp(1)+axis_temp(3)-1) ;
%                             Image_torigplate{temp} = image_orig{i}(axis_temp(2):axis_temp(2)+axis_temp(4)-1,axis_temp(1):axis_temp(1)+axis_temp(3)-1,:);
%                             figure, imshow(Image_torigplate{temp})
%                             %ratio=Colorselect(Image_torigplate{temp});
%                             % rgb 转 hsv 空间判断颜色
%                             HSV = rgb2hsv(Image_torigplate{temp});
%                             ratio = Colorselecthsv(HSV);
%                             
%                       end
%                 end     
%        end
%    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%9.8%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%连通域法%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           temp4loc = edge(image_gray{i},'canny'); % canny算子可以显示出更多的细节
           count_lt = 0 ; 
           figure,imshow(temp4loc)
           % 连通域标记 采用4连通
           L = bwlabel(temp4loc,4);
           % 参数反馈
           stats = regionprops(logical(L),'BoundingBox','Image','Centroid');
           % 作图
                for ii = 1 : length(stats)
                      hold on;
                      [h,w] = size(stats(ii).Image);
                      temp_s = h * w  ;
                      temp_r = h / w ;
                      %temp_a = sum(sum(stats(ii).Image));
                      if temp_s > 100 && h / w > 1.5 && temp_s<=400&& h / w< 3  %  constraints
                            rectangle('position',stats(ii).BoundingBox,'edgecolor','g','linewidth',2);  % 测试，还未存储
                            axis_temp = ceil(stats(ii).BoundingBox);  % 获取坐标[x,y,width,height]
                            count_lt = count_lt + 1;
                            % 临时变量 
                            sQtemp = struct(sQ);
                            sQtemp.center = stats(ii).Centroid ;
                            sQtemp.height = axis_temp(4);
                            sQtemp.width = axis_temp(3);
                            ltsQ(count_lt) = sQtemp;
                            ltsize(count_lt) = temp_s;
                            ltratio(count_lt) = temp_r;
                            % -1是为了不越界
                            ltaxis{count_lt} = axis_temp;
                            temp4loc(axis_temp(2):axis_temp(2)+axis_temp(4)-1,axis_temp(1):axis_temp(1)+axis_temp(3)-1) = 1;
                            % 清除临时变量
                            clearvars sQtemp axis_temp
%                             Image_tgrayplate{temp} = image_gray{i}(axis_temp(2):axis_temp(2)+axis_temp(4)-1,axis_temp(1):axis_temp(1)+axis_temp(3)-1) ;
%                             Image_torigplate{temp} = image_orig{i}(axis_temp(2):axis_temp(2)+axis_temp(4)-1,axis_temp(1):axis_temp(1)+axis_temp(3)-1,:);
%                             figure, imshow(Image_torigplate{temp})
                            %ratio=Colorselect(Image_torigplate{temp});
                            % rgb 转 hsv 空间判断颜色
%                             HSV = rgb2hsv(Image_torigplate{temp});
%                             ratio = Colorselecthsv(HSV);
                            
                      end
                end  
               
                if count_lt >= 3
                    [ltsQ_out,max_count,max_neibor,sQ_switch] = deNeibor(ltsQ,count_lt);
                    xywh = zeros(1,4);
                    % 绘图
                    xywh(1) = floor(max(1,ltsQ_out(max_count).center(1,1) - 8 * ltsQ_out(max_count).width)); %x
                    xywh(2) = floor(max(1,ltsQ_out(max_count).center(1,2) - ltsQ_out(max_count).height * 0.6));%y
                    xywh(3) = floor(ltsQ_out(max_count).width*10);%w
                    xywh(4) = floor(ltsQ_out(max_count).height*1.5);%h
                    %xywh = [ max(1,ltsQ_out(max_count).center(1,1) - 10 * ltsQ_out(max_count).width) , max(1,ltsQ_out(max_count).center(1,2) - ltsQ_out(max_count).height * 1.2)
                    %        ltsQ_out(max_count).width*10 , ltsQ_out(max_count).height*1.5];
                    %xywh = floor(xywh);
                    rectangle('position',xywh,'edgecolor','r','linewidth',2);
                    count_wt = count_wt+1;
                    image_lt{count_wt} = temp4loc; %存储开运算之前的
                    ltratio(ltratio==min(ltratio)) = 0 ;
                    ltratio(ltratio==max(ltratio)) = 0 ;
                    sort2ratio_temp = zeros(1,count_lt) ;
                    sort2ratio = zeros(1,count_lt-2) ;
                    sort2ratio_temp = sort(ltratio);
                    sort2ratio = sort2ratio_temp(3:count_lt);
                    clearvars sort2ratio_temp
                    sort2ratio_diff = abs(diff(sort2ratio));
                    ind4sort = find(sort2ratio_diff == 0);
                    l_ind = length(ind4sort);
                    
                    
                    
                    a = min(ltsize);
                    temp4loc = bwareaopen(temp4loc,a-1);
%                     SE = strel('square',30);
%                     temp4loc = imdilate(temp4loc,SE);
%                     temp4loc = imerode(temp4loc,SE);
                    figure, imshow(temp4loc);
                end
%                 for  iii = 1 : count_lt
                    
                    
       end
   end
       
       
       
       
%    [height,width] = size(I_eff_gray_below);
%    I_and = zeros(height,width);
%    % 窗口B下的均值
%    I_first_and = averagefilter(I_eff_gray_below,[3 3]);
%    % 窗口a下的均值
%    I_second_and = averagefilter(I_eff_gray_below,[7 7]);
%    % 比值
%    I_temp_and = I_second_and./I_first_and;
%    % scw阈值//必须要大于1
%    scw_thr = 1.2;
%    % 比较
%    for i = 1:height
%        for j = 1:width
%        if I_temp_and(i,j)>scw_thr 
%            I_and(i,j) = 1 ;
%        else I_and(i,j) = 0; end
%        end
%    end
%    % mask
%    I_mask = uint8(I_and).*I_eff_gray_below;

   
       
       
           
        
        
                        
            
            

