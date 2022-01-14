addpath(genpath('./m'))

x = [3; 4; 11; 15];
y = [2; 7; 12; 20];
epsilon = [6; 9; 13; 8];

X = [ x.^0 x ];
lowerBounds = [-inf 0];
irp_steam = ir_problem(X, y, epsilon, lowerBounds);
b_int = ir_outer(irp_steam)


%%%   Информационное множество   %%%
[rhoB, b1, b2] = ir_betadiam(irp_steam);
b_maxdiag = (b1 + b2) / 2;
b_gravity = mean(ir_beta2poly(irp_steam));
b_lsm = (X \ y)';
figure
ir_plotbeta(irp_steam);
hold on
plot(b_maxdiag(1), b_maxdiag(2), ';максимальная диагональ;ro');
plot(b_gravity(1), b_gravity(2), ';центр тяжести;go');
plot(b_lsm(1), b_lsm(2), ';мнк;bo');

grid on
legend();
xlabel('b1');
ylabel('b2');



%%%   Коридор зависимостей   %%%
figure 
xlimits = [0 20];
ir_plotmodelset(irp_steam, xlimits)
hold on
ir_scatter(irp_steam,'b.')
grid on
xlabel('x')
ylabel('y')


%%%   Предсказание   %%%
x_p = [10; 12; 16; 22.5];
X_p = [x_p.^0 x_p];
y_p = ir_predict(irp_steam, X_p)
