      I = imread('eight.tif');
      J = averagefilter(I, [3 3]);
      figure, imshow(I), figure, imshow(J)