%%
A1 = [1.0, 1.0; 1.0, -infsup(2.0, 3.0)];
b1 = [infsup(1.0, 4.0); 0.0];

%%%   LINEAR   %%%
L = inv(mid(A1));
C = eye(2)-L*A1;

%%%   Kravchik   %%%
box0 = [infsup(-3.38, 3.38); infsup(-3.38, 3.38)];
n = 20;
boxes = [box0];
x = box0;
for i=1:n
    x = intersect(L*b1 + C*x, x);
    boxes = [boxes x];
end
figure
[V,P1,P2,P3,P4] = EqnWeakR2(inf(A1), sup(A1), inf(b1), sup(b1));
hold on
plotintval(boxes, 'n')
grid on

%%%   Graphs   %%%
rads = zeros(2, size(boxes, 2));
dists = zeros(1, size(boxes, 2));
last_center = mid(boxes(:, size(boxes, 2)));
for i=1:size(boxes, 2)
    rads(:, i) = rad(boxes(:, i));
    dists(1, i) = norm(mid(boxes(:, i)) - last_center);
end

figure
plot(rads(1, :))
ylabel('Радиус по горизонтали')
xlabel('Номер итерации')
grid on

figure
plot(rads(2, :))
ylabel('Радиус по вертикали')
xlabel('Номер итерации')
grid on

figure
semilogy(dists)
ylabel('Расстояние от предыдущего центра')
xlabel('Номер итерации')
grid on

%% 
%%%   NON LINEAR   %%%
A = @(x) [1.0, 1.0; x(1) ./ x(2), 0];
b = [infsup(1.0, 4.0); infsup(2.0,3.0)];
% якобиан
J = @(x) [1, 1; 1 /x(2), -x(1)./(x(2)*x(2))];

%%% Kravchik operator %%%
L = @(x) inv(mid(J(x)));
F = @(x) [x(1)+x(2)-infsup(1.0, 4.0); x(1)./x(2)-infsup(2.0,3.0)];
K = @(x) mid(x)-L(x)*F(mid(x))-(eye(2)-L(x)*J(x))*(x - mid(x));

%%%   Kravchik   %%%
box0 = [infsup(0.2, 7); infsup(0.2,5)]
n = 300;
boxes = [box0];
x = box0;
for i=1:n
    x = intersect(K(x), x);
    boxes = [boxes x];
end
figure
[V,P1,P2,P3,P4] = EqnWeakR2(inf(A1), sup(A1), inf(b1), sup(b1));
hold on
hold on
plotintval(boxes, 'n')
grid on

%%%   Graphs   %%%
rads = zeros(2, size(boxes, 2));
dists = zeros(1, size(boxes, 2));
last_center = mid(boxes(:, size(boxes, 2)));
for i=1:size(boxes, 2)
    rads(:, i) = rad(boxes(:, i));
    dists(1, i) = norm(mid(boxes(:, i)) - last_center);
end

figure
plot(rads(1, :))
ylabel('Радиус по горизонтали')
xlabel('Номер итерации')
grid on

figure
plot(rads(2, :))
ylabel('Радиус по вертикали')
xlabel('Номер итерации')
grid on

figure
semilogy(dists)
ylabel('Расстояние от предыдущего центра')
xlabel('Номер итерации')
grid on