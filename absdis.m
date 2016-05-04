function d = absdis(pointA,pointB)
    A = zeros(1,2);   B = zeros(1,2);
    A(1) = pointA(1); A(2) = pointA(2);
    B(1) = pointB(1); B(2) = pointB(2);
    d = sqrt( ( A(1) - B(1) )^2 + ( A(2) - B(2) )^2 );
end
    