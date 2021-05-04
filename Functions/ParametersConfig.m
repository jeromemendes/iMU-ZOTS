
%% variable lim_{it}
limit_it = gui.Limit; % maximal number of learning interactions,

%% variable \epsilon
limit_theta = gui.epsilon; % Termination condition defined on Algorithm 2 Step 2.b.ii. The value depends on the value of thetas. Zero to no terminal condition.

%% Threshold M_th (Criterion 1)
th_M = gui.M_th; % the same for all variables

%% Maximal number of MF - for Threshold \eta_j (Criterion 2)
eta = gui.maxMF;  % the same for all variables

%% Other variables definition
per_extra = 0.050; % 5% (suggest keeping it fixed) - percentage extra to increase the limits of the universe of discourse of the input variables
