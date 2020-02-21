
%lambda
data1 = load('task103_travel.mat');
data1 = data1.travel;

t = data1(1, :);

lambda_measured = data1(2, :);
lambda_opt = data1(3, :);

p_measured = data1(4, :);
p_opt = data1(5, :);

%Plot
figure(1)
plot(t, lambda_measured);
hold on;
plot(t, lambda_opt);
hold on;
legend('\lambda_{measured}', '\lambda_{optimal}');
xlim([0, 18.3]);
xlabel('Time [sec]')
ylabel('Travel [deg]')
print -depsc task103_travel_10

figure(2)
plot(t, p_measured);
hold on;
plot(t, p_opt);
hold on;
yline((30*pi)/180,'-.b' );
legend('p_{measured}', 'p_{optimal}');
xlim([0, 18.3]);
xlabel('Time [sec]')
ylabel('Pitch [deg]')
print -depsc task103_p_10