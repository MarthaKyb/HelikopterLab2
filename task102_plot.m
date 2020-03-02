
%p = 0.1
data01 = load('task102_4_p01.mat');
data01 = data01.p01;

t01 = data01(1, :);

u01 = data01(2, :);
lambda01 = data01(3, :);

%p = 1
data1 = load('task102_4_p1.mat');
data1 = data1.p1;

t1 = data1(1, :);

u1 = data1(2, :);
lambda1 = data1(3, :);


%p = 10
data10 = load('task102_4_p10.mat');
data10 = data10.p10;

t10 = data10(1, :);

u10 = data10(2, :);
lambda10 = data10(3, :);


%Plot - input u
figure(1)
plot(t01, rad2deg(u01));
hold on;
plot(t1, rad2deg(u1));
plot(t10, rad2deg(u10));
xlim([0, 17]);
ylim([-40, 40]);
xlabel('Time [s]');
ylabel('Input [deg]');
legend('u_{p=0.1}', 'u_{p=1}', 'u_{p = 10}');
print -depsc input_u_final


%Plot - travel
figure(2)
plot(t01, lambda01);
hold on;
plot(t1, lambda1);
plot(t10, lambda10);
xlim([0, 17]);
xlabel('Time [s]');
ylabel('Travel [deg]');
legend('lambda_{p=0.1}', 'lambda_{p=1}', 'lambda_{p=10}', 'Location', 'SouthWest');
print -depsc travel_t_final

