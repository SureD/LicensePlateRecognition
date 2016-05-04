function I_and = Scw(imageI,threshold,windowA,windowB)
% Use Scw method to filtering two dimensional picture
%   Input:
%         imageI : grayscale picture.
%         threshold : the Scw method's threshold , usually bigger than '1'.
%         windowA & windowB : the size of each pixel's neighborhood, In the Scw method
%                          we define that windowB is always belong to windowA.
%   Output:
%         I_and : a logical matrix ,using to mask the grayscale picture ,
%                 However, we do not utilize that in this function.
%  
%   -------
%   The averagefilter function contributed by Jan Motl makes this method
%   more faster than before, and his amazing idea of the pixel's neibor
%   impressd me , then I complished this function effectively.
%
%   Example
%   -------
%       I = imread('eight.tif');
%       J = Scw(I,1.2,[7 7],[3 3]);
%       figure, imshow(I), figure, imshow(J)
%   Contributed by Shuo Deng (dengshuo346@gmail.com)
%   $Date: 2013/07/25 21:42 $
   [height,width] = size(imageI);
   I_and = zeros(height,width);
   m = windowA(1);
   n = windowA(2);
   p = windowB(1);
   q = windowB(2);
   % 窗口B下的均值
   I_first_and = averagefilter(imageI,[p q]);
   % 窗口A下的均值
   I_second_and = averagefilter(imageI,[m n]);
   % 比值
   I_temp_and = I_second_and./I_first_and;
   % scw阈值//必须要大于1
   % 比较
   for i = 1:height
       for j = 1:width
       if I_temp_and(i,j)>threshold 
           I_and(i,j) = 1 ;
       else I_and(i,j) = 0; end
       end
   end
   I_and=uint8(I_and);
end
%    mask
%    I_mask = uint8(I_and).*I_eff_gray_below;