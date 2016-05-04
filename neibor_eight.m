function linju=neibor_eight(i,j,enviro)
% NEIBOR 求取粒子enviro(i,j)在环境enviro中的8个邻居
%  i     指定粒子在环境enviro中的行标
%  j     指定粒子在环境enviro中的列标
% enviro 指定粒子所在的环境
% linju  粒子enviro(i,j)在环境enviro中的8个邻居，是一个有8个元素的行向量
  [r_num,c_num]=size(enviro);
  i1=mod(i+r_num-2,r_num)+1;
  i2=mod(i,r_num)+1;
  j1=mod(j+c_num-2,c_num)+1;
  j2=mod(j,c_num)+1;
  linju=[enviro(i1,j);enviro(i1,j2);enviro(i,j2);enviro(i2,j2);enviro(i2,j);enviro(i2,j1);enviro(i,j1);enviro(i1,j1)];