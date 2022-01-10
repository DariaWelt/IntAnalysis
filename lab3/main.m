Tol = @(A,b,x) min(rad(b) - mag(mid(b) - A * x));

A = [infsup(1, 2), infsup(1, 3); 1, -infsup(1, 3); infsup(1, 2), 0];
b = [infsup(1, 2); 0; infsup(4, 5)];


[tolMax,argMax,envs,ccode] = tolsolvty(inf(A), sup(A), inf(b), sup(b));
%%%   Tolgraph   %%%
n = 100;
levels = 30;
drawTol(A,b,n,levels)


%%%   vector b correction   %%%
e = [infsup(-1, 1); infsup(-1, 1); infsup(-1, 1)];
C = 1.5 * abs(tolMax);
b1 = b + C * e;
drawTol(A,b1,n,levels)