
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
plot(t01, u01);
hold on;
plot(t1, u1);
hold on;
plot(t10, u10);
legend('u_{p=0.1}', 'u_{p=1}', 'u_{p = 10}');
print -depsc input_u_final


%Plot - travel
figure(2)
plot(t01, lambda01);
hold on;
plot(t1, lambda1);
hold on;
plot(t10, lambda10);
legend('lambda_{p=0.1}', 'lambda_{p=1}', 'lambda_{p=10}');
print -depsc travel_t_final

