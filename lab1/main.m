% bar for solution
X =  [infsup(-10, 10);infsup(-10, 10)];

[Z, worklist] = globopt0(X);
n = 100;
x_grid = linspace(inf(X(1)), sup(X(1)), n);
y_grid = linspace(inf(X(2)), sup(X(2)), n);
[xx, yy] = meshgrid(x_grid, y_grid);
zz = (xx*xx+yy-11)+(xx+yy*yy-7);

% Himmelblaw
answer = [3 2;-2.805118 3.131312;-3.779310 -3.283186;3.584428 -1.848126];
answerY = 0;

% Rastrygin
%answer = [0 0]
%answerY = -2

%%%   Z DIST   %%%
figure
answer = answer';
dists = zeros(1, size(worklist, 2));
rads = dists;
for i=1:size(worklist, 2)
    dists(1, i) = min(vecnorm(answer - mid(worklist(i).Box)));
    vecnorm(0 - mid(worklist(i).Box))
    rads(1, i) = max(rad(worklist(i).Box));
end
semilogy(dists, "LineWidth", 1)
hold on
grid on
title('Максимальное расстояние от точного значения')
xlabel('номер итерации')
ylabel('расстояние')
xlim([0 size(worklist, 2)])

%%%   RADIUS LIST   %%%
figure
semilogy(rads, "LineWidth", 1)
hold on
grid on
title('Больший радиус бруса')
xlabel('номер итерации')
ylabel('радиус')
xlim([0 size(worklist, 2)])

%%%   BOXES   %%%
figure
contour(xx, yy, zz, 36, 'k')
hold on
opt_int = worklist(1).Box;
min_est = inf;
max_est = inf;
for b = worklist
    if b.Estim < min_est
        opt_int = b.Box;
        min_est = b.Estim;
        max_est = b.EstimUp;
    end
    plotintval(b.Box, 'n');
    hold on
end
