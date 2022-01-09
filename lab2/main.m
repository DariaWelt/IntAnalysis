A = [1.0, 1.0; 1.0, -infsup(2.0, 3.0)];
b = [infsup(1.0, 4.0); 0.0];

%%%   LINEAR   %%%
figure
L = inv(mid(A));
C = eye(2)-L*A;

%%%   Kravchik   %%%
box0 = [infsup(-3.38, 3.38); infsup(-3.38, 3.38)];
n = 20;
boxes = [box0];
x = box0;
for i=1:n
    x = intersect(L*b + C*x, x);
    boxes = [boxes x];
end
[V,P1,P2,P3,P4] = EqnWeakR2(inf(A), sup(A), inf(b), sup(b));
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
legend('x1', 'x2')
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

%%%   NON LINEAR   %%%
