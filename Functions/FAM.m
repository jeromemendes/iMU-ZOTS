% For use with Matlab
% Copyright (C) 2019 -- Jerome Mendes <jermendes@gmail.com> or <jermendes@isr.uc.pt>, Rui Araujo <rui@isr.uc.pt>
% Jerome Mendes, Francisco A. A. Souza, Ricardo Maia, and Rui Araujo. "Iterative learning of multiple univariate zero-order t-s fuzzy systems". IEEE 45th Annual Conference of the Industrial Electronics Society (IECON 2019), 2019.
% The "iMU-ZOTS toolbox" comes with ABSOLUTELY NO WARRANTY;
% In case of publication of any application of this method, please, cite the work:
% Jerome Mendes, Francisco A. A. Souza, Ricardo Maia, and Rui Araujo. 
% Iterative learning of multiple univariate zero-order t-s fuzzy systems.
% In Proc. of the The IEEE 45th Annual Conference of the Industrial Electronics Society (IECON 2019), pages 3657–3662, Lisbon, Portugal, October 14-17 2019. IEEE. 
% DOI: http://doi.org/10.1109/IECON.2019.8927224
% http://www.isr.uc.pt/~jermendes/    ;     http://www.isr.uc.pt/~rui/

function [x] = FAM (data_ytrain, data_xtrain, limit_it, limit_theta, dataTotal_x, per_extra, N, eta)
    %% Description
    % This function represents the GAM-ZOTS learning algorithm (Algorithm
    % 2) to be used as an initialization on Algorithm 3.
    %% Function inputs
    % data_ytrain - Train dataset of ouput variables
    % data_xtrain - Train dataset of input variable
    % limit_it - maximal number of learning interactions - variable lim_{it}
    % limit_theta - Termination condition - variable \epsilon
    % dataTotal_x - All dataset of input variables
    % per_extra - percentage extra to increase the limits of the universe of
    % discourse of the input variables
    % N - Number of fuzzy rules per input variable
    % eta - threshould to define a minimal distance between MFs (Criterion 2)
    %% Function output
    % x - Struct with all parameters of the fuzzy system


%% Fuzzy Rules Design Initialization - Algorithm 3 Step 2
x = Initialization (dataTotal_x, per_extra, N, eta); % Definition of the struct that contain all parameters information; and Define/design the antecedent part

%% Consequent Design  - Algorithm 3 Step 3 
omega_all = Initialization_omega_all (data_xtrain, x); % initialization with zeros of the variable \omega for all dataset
omega_all = Epsilons_all_C_opt(data_xtrain, x, omega_all); % This function obtains the value of the variable \omega for all dataset

x  = AdditiveModels_C_opt(data_ytrain, data_xtrain, x, limit_it, limit_theta, omega_all); % This function performs the GAM-ZOTS method (Algorithm 2)

end
