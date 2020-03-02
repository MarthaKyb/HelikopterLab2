data1 = load('task104_no_feedback_update.mat');
data1 = data1.var_noF;

select = 1:125:length(data1);
t = data1(1, :);
t = t(select);

e_measured = data1(2, select);
e_opt = data1(3, select);

lambda_measured = data1(4, select);
lambda_opt = data1(5, select);

p_measured = data1(6, select);
p_opt = data1(7, select);


%Constraint

alpha = 0.2;
beta = 20;
lambda_t = 2*pi/3;
e_con = @(lambda_k) alpha*exp(-beta*(lambda_k - lambda_t).^2);

% %Plot e
figure(1)
plot(t, e_measured);
hold on;
plot(t, e_opt);
hold on;
plot(t, rad2deg(e_con(deg2rad(lambda_opt))), '-.k', 'LineWidth', 1);
legend('e_{measured}', 'e_{optimal}', 'e_{constraint}');
xlabel('Time [s]');
ylabel('Elevation [deg]');
xlim([0, 25]);
print -depsc task104_e_no_feedback_update


% %Plot lambda
figure(2)
plot(t, lambda_measured);
hold on;
plot(t, lambda_opt);
hold on;
legend('\lambda_{measured}', '\lambda_{optimal}');
xlabel('Time [s]');
ylabel('Travel [deg]');
xlim([0, 25]);
print -depsc task104_travel_no_feedback_update

% %Plot p
figure(3)
plot(t, p_measured);
hold on;
plot(t, p_opt);
yline(rad2deg((30*pi)/180), '-.k', 'LineWidth', 1);
yline(-rad2deg((30*pi)/180), '-.k', 'LineWidth', 1);
legend('p_{measured}', 'p_{optimal}', 'p_{constraint}');
xlabel('Time [s]');
ylabel('Pitch [deg]');
xlim([0, 25]);
ylim([-35, 35]);
print -depsc task104_p_no_feedback_update