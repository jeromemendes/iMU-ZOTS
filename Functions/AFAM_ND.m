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

function [x] = AFAM_ND ( x, data_ytrain, data_xtrain, limit_it, limit_theta,th_M)
%% Description
% This function represents the iterative learning of iMU-ZOTS algorithm (Algorithm 3 Step 4).
%% Function inputs
% x - Struct with all parameters of the fuzzy system
% data_ytrain - Train dataset of ouput variables
% data_xtrain - Train dataset of input variable
% limit_it - maximal number of learning interactions - variable lim_{it}
% limit_theta - Termination condition - variable \epsilon
% th_M - Threshold M_th (Criterion 1)
%% Function output
% x - Struct with all parameters of the fuzzy system


L = size(data_xtrain, 1); % dataset size
n_var = size(data_xtrain, 2); % number of input variables

k = 1;

while 1 % Until termination condition be satified. If a fuzzy rule hasn’t been added, then exit to the learning process (sum(Add)==0)
    
    ini = 1;  % Flag which represents the initial of the iterative learning
    Add = zeros(1, n_var); % Flag to know if a rule was added
    
    %% Initialization of the Novelty Measuring (NM) struct
    
    for j_NM = 1 : length( x ) % for each input variable
        
        n_rules = size( x(j_NM).Rules,1 ); % number of rules of variable j_NM
        
        for i = 1 : n_rules % for each rule of variable j_NM
            
            NM(j_NM).N_i(i) = 0; %  Initialization of the total membership function degrees associated to the i-th MF of j_NM (equation 9)
            NM(j_NM).mu_i(i) = 0; % Initialization of the fuzzy degree of i-th MF of j_NM (equation 8)
        end
    end
    
    
    %% For all train dataset - Algorithm 3 Step 4a
    for l = 1 : L % For all dataset
        
        x_data = data_xtrain(l,:); % Input value at instant l
        
        %% Measure the novelty for all input variables - Algorithm 3 Step 4ai
        [M, NM, ini] = NoveltyMeasuring(x, NM, x_data, ini);
        
        %% New rules if criteria are met - Algorithm 3 Step 4aii
        for j = 1:n_var
            
            if  M(j) > th_M % Novelty detection criterion
                
                [left_MF, right_MF] = LocateMFnearest(x_data(j), x(j)); % locates the nearest left and right MFs to the candidate MF (MF_center)
                
                [x, Add, NM] = AddMF_NovMea(x, j, x_data(j), left_MF, right_MF, NM, Add); % Adds new rules if criteria 1 and 2 are met -  Algorithm 3 Step 4aiiA
                
            end
            
        end
        
        %% Update the consequents -  Algorithm 3 Step 4aiiB
        if sum(Add) > 0
            
            omega_all = Initialization_epsilons_all (data_xtrain, x); % initialization with zeros of the variable \omega for all dataset
            omega_all = Epsilons_all_C_opt(data_xtrain, x, omega_all); % This function obtains the value od the variable \omega for all dataset
            
            x  = AdditiveModels_C_opt(data_ytrain, data_xtrain, x, limit_it, limit_theta, omega_all); % This function performs the GAM-ZOTS method (Algorithm 2)
            
        end
    end
    
    %% Termination condition -  Algorithm 3 Step 4b
    if sum(Add)  == 0
        break
    end
    
end

end