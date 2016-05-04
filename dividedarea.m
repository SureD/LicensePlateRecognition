%划分有效域
function [prob_area]=dividedarea(linesdata,lines_length,truelines_length)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 输入： 霍夫变换检测到直线的数据，包括：线的起点，线长度，绝对长度，一个标志
% %% 函数通过能量函数 E=axis_weight*x+distance(...),确定一个信息最集中的点来分割图像
% 输出：分割的坐标及其最大长度值
%  dengshuo 7.23 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  problinesdata(1,truelines_length)=struct('x',[],'linenorm',[],'abslength',[],'switch',[]);
  i=1;
  length=zeros(1,truelines_length);
  for k=1:lines_length
      if linesdata(k).switch==1
            problinesdata(i)=linesdata(k);
            length(i)=linesdata(k).abslength;
            i=i+1;
            
      end
  end
  problength=max(length);
  axis_w=0; % 横坐标权重系数
  energy=zeros(1,truelines_length); %能量
  for k=1:truelines_length
        for i=1:truelines_length 
%             energy(k)=1.5*distance(problinesdata(k).x,problinesdata(i).x)+energy(k)+abs(problinesdata(k).x(1,1)-problinesdata(i).x(1,1));
              energy(k)=1.5*absdis(problinesdata(k).x,problinesdata(i).x)+energy(k)+abs(problinesdata(k).x(1,1)-problinesdata(i).x(1,1));
        end
        energy(k)=energy(k)+axis_w*problinesdata(k).x(1,1);
  end
 energy_shadow=sort(energy);
 sub_x1= energy==energy_shadow(1);
 %sub_x2= energy==energy_shadow(2);
 probpoint1=problinesdata(sub_x1).x;
 %probpoint2=problinesdata(sub_x2).x;
 prob_area(1)=struct('point',probpoint1,'length',problength);
 %prob_area(2)=struct('point',probpoint2,'length',problength);
end
 
 
 
  
          
      