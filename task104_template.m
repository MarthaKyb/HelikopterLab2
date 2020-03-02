% TTK4135 - Helicopter lab
% Hints/template for problem 2.
% Updated spring 2018, Andreas L. Fl�ten

%% Initialization and model definition
init08; % Change this to the init file corresponding to your helicopter

% Discrete time system model. x = [lambda r p p_dot]'
delta_t	= 0.25; % sampling time

% System matrices
A = [0          1           0           0       0           0;
     0          0         -K_2          0       0           0;
     0          0           0           1       0           0;
     0          0       -K_1*K_pp   -K_1*K_pd   0           0;
     0          0           0           0       0           1;
     0          0           0           0   -K_3*K_ep   -K_3*K_ed];
B = [0      0; 
     0      0; 
     0      0; 
  K_1*K_pp  0; 
     0      0;
     0   K_3*K_ep];

% Discrete matrices
Ad = eye(6)+delta_t*A;
Bd = delta_t*B;

A1 = Ad;
B1 = Bd;

% Number of states and inputs
mx = size(A1,2); % Number of states (number of columns in A)
mu = size(B1,2); % Number of inputs(number of columns in B)

% Initial values
u1_0 = 0;
u2_0 = 0;
x1_0 = pi;                              % Lambda
x2_0 = 0;                               % r
x3_0 = 0;                               % p
x4_0 = 0;                               % p_dot
x5_0 = 0;                               %e
x6_0 = 0;                               %e_dot
x0 = [x1_0 x2_0 x3_0 x4_0 x5_0 x6_0]';           % Initial values

% Time horizon and initialization
N  = 40;                                % Time horizon for states
M  = N;                                 % Time horizon for inputs
z  = zeros(N*mx+M*mu,1);                % Initialize z for the whole horizon
z0 = z;                                 % Initial value for optimization
z0(1) = pi;

% Bounds
ul 	    = [-(30*pi)/180; -Inf];                % Lower bound on control
uu 	    = [(30*pi)/180; Inf];                  % Upper bound on control

xl      = -Inf*ones(mx,1);              % Lower bound on states (no bound)
xu      = Inf*ones(mx,1);               % Upper bound on states (no bound)
xl(3)   = ul(1);                        % Lower bound on state x3
xu(3)   = uu(1);                        % Upper bound on state x3

% Generate constraints on measurements and inputs
[vlb,vub]       = gen_constraints(N,M,xl,xu,ul,uu);
vlb(N*mx+M*mu)  = 0;                    % We want the last input to be zero
vub(N*mx+M*mu)  = 0;                    % We want the last input to be zero

% Generate the matrix Q and the vector c (objecitve function weights in the QP problem) 
Q1 = zeros(mx,mx);
Q1(1,1) = 2;                            % Weight on state x1
Q1(2,2) = 0;                            % Weight on state x2
Q1(3,3) = 0;                            % Weight on state x3
Q1(4,4) = 0;                            % Weight on state x4
Q1(5,5) = 0;                            % Weight on state x5
Q1(6,6) = 0;                            % Weight on state x6
P1 = 2;                                 % Weight on input u1 - pc
P2 = 2;                                 % Weight on input u2 - ec
P1m =diag([P1, P2]);
Q = gen_q(Q1,P1m,N,M);                  % Generate Q

func = @(z)(1/2)*(z'*Q*z);              % Objective function

%% Generate system matrixes for linear model
Aeq = gen_aeq(A1,B1,N,mx,mu);                             % Generate A
beq = [A1*x0; zeros(234,1)];                              % Generate b

options = optimoptions('fmincon','Algorithm','sqp','MaxFunEvals', 50000);

%% Solve SQP problem with unlinear constraints
tic
[z,lambda] = fmincon(func, z0, [] ,[], Aeq, beq, vlb, vub, @ineqcon, options); 
t1=toc;

% Unlinear constraint vector
[c, c_eq] = ineqcon(z);

c = rad2deg(c);

% Calculate objective value
phi1 = 0.0;
PhiOut = zeros(N*mx+M*mu,1);
for i=1:N*mx+M*mu
  phi1=phi1+Q(i,i)*z(i)*z(i);
  PhiOut(i) = phi1;
end

%% Extract control inputs and states
u1 = [u1_0;z(N*mx+1:2:N*mx+M*mu)];      % Control input pc
u2 = [u2_0;z(N*mx+2:2:N*mx+M*mu)];      % Control input ec
x1 = [x0(1);z(1:mx:N*mx)];              % State x1 from solution
x2 = [x0(2);z(2:mx:N*mx)];              % State x2 from solution
x3 = [x0(3);z(3:mx:N*mx)];              % State x3 from solution
x4 = [x0(4);z(4:mx:N*mx)];              % State x4 from solution
x5 = [x0(5);z(5:mx:N*mx)];              % State x5 from solution
x6 = [x0(6);z(6:mx:N*mx)];              % State x6 from solution

num_variables = 5/delta_t;
zero_padding = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);

c = [zero_padding; c ;zero_padding];
u1  = [zero_padding; u1; zero_padding];
u2  = [zero_padding; u2; zero_padding];
x1  = [pi*unit_padding; x1; zero_padding];
x2  = [zero_padding; x2; zero_padding];
x3  = [zero_padding; x3; zero_padding];
x4  = [zero_padding; x4; zero_padding];
x5  = [zero_padding; x5; zero_padding];
x6  = [zero_padding; x6; zero_padding];
x = [x1 x2 x3 x4 x5 x6]; 

t = 0:delta_t:delta_t*(length(u1)-1);
%t_x = 0:delta_t:delta_t*(length(x)-1);


% LQC - Wight matrices
Q_lqr = diag([10, 1, 1, 0.1, 15, 1]);
             %l  %r  %p %p_dot %e %e_dot
R_lqr = diag([1, 0.1]); 
          %p_c  %e_c

% Discrete time system model. x = [lambda r p p_dot]'

% LQC - Gain matrix
[K, S, e] = dlqr(Ad, Bd, Q_lqr, R_lqr);

% Optimal state vector
x_star = [t' x1 x2 x3 x4 x5 x6];

% Optimal input vector
u_star = [t', u1, u2];




%% Plotting
% 
% figure(2)
% subplot(811)
% stairs(t,u1),grid
% ylabel('p_c')
% ylim([-0.5, 0.5]);
% subplot(812)
% stairs(t,u2),grid
% ylabel('e_c')
% ylim([-0.2, 0.5]);
% subplot(813)
% plot(t,x1,'m',t,x1,'mo'),grid
% ylabel('Travel')
% subplot(814)
% plot(t,x2,'m',t,x2','mo'),grid
% ylabel('Travel rate')
% subplot(815)
% plot(t,x3,'m',t,x3,'mo'),grid
% ylabel('Pitch')
% ylim([-0.7, 0.7]);
% subplot(816)
% plot(t,x4,'m',t,x4','mo'),grid
% ylabel('Pitch rate')
% ylim([-0.7, 0.7]);
% subplot(817)
% plot(t,x5,'m',t,x5','mo'),grid
% ylabel('Elev.')
% subplot(818)
% plot(t,x6,'m',t,x6','mo'),grid
% xlabel('Time [sec]'),ylabel('Elev. rate')
% ylim([-0.5, 0.5]);
% print -depsc task104_optimal

