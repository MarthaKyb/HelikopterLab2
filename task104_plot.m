%task104_template;

data1 = load('task104.mat');
data1 = data1.var;

t = data1(1, :);

e_measured = data1(2, :);
e_opt = data1(3, :);

lambda_measured = data1(4, :);
lambda_opt = data1(5, :);

p_measured = data1(6, :);
p_opt = data1(7, :);

%Plot e

% figure(1)
% plot(t, e_measured);
% hold on;
% plot(t, e_opt);
% hold on;
% %plot(-c);
% hold on;
% legend('e_{measured}', 'e_{optimal}');
% xlabel('Time [sec]');
% ylabel('Elevation [deg]');
% xlim([0, 22]);
% print -depsc task104_e

% 
% % %Plot lambda
% figure(2)
% plot(t, lambda_measured);
% hold on;
% plot(t, lambda_opt);
% hold on;
% legend('\lambda_{measured}', '\lambda_{optimal}');
% xlabel('Time [sec]');
% ylabel('Travel [deg]');
% xlim([0, 22]);
% print -depsc task104_travel
% % 
% % %Plot p
figure(3)
plot(t, p_measured);
hold on;
plot(t, p_opt);
hold on;
yline(rad2deg((30*pi)/180),'-.b' );
hold on;
yline(-rad2deg((30*pi)/180),'-.b' );
hold on;
legend('p_{measured}', 'p_{optimal}', 'p_{constraint}');
xlabel('Time [sec]');
ylabel('Pitch [deg]');
xlim([0, 22]);
ylim([-35, 35]);
print -depsc task104_p