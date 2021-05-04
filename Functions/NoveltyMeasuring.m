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

function [M, NM, ini] = NoveltyMeasuring(x, NM, data_input, ini)
%% Description
% This function measure the novelty for all input variables - Algorithm 3 Step 4ai
%% Function inputs
% x - Struct with all parameters of the fuzzy system
% NM - Struct with the parameters of the Novelty Measuring (NM)
% data_input - Values of input variables
% ini -
%% Function output
% M - Variable M_{j,max} - Criterion 1, equation 10
% NM - Struct with the parameters of the Novelty Measuring (NM)
% ini - Flag which represents the initial of the iterative learning


xN_var= length(x); % number of inputs variables
M = zeros(1, xN_var); % initialization of M

for j_NM = 1 : xN_var % for each input variable
    
    n_rules = size( x(j_NM).Rules,1 ); % number of rules
    M_i_j = zeros(1, n_rules); %initialization of the Novelty values
    
    for i = 1 : n_rules % for each rule of j_NM
        
        N_i_ant = NM(j_NM).N_i(i); % previous total membership function degrees associated to the i-th MF of j_NM (first term equation 9)
        mu_i_ant = NM(j_NM).mu_i(i); % previous fuzzy degree of i-th MF of j_NM (first term of equation 8)
        
        %% Obtain the fuzzy triangular membership functions degree
        parameters = zeros(1,3);
        parameters(1,1) = x(j_NM).Rules(i,1); % parameter a_{j,i};
        parameters(1,2) = x(j_NM).Rules(i,2); % parameter b_{j,i};
        parameters(1,3) = x(j_NM).Rules(i,3); % parameter c_{j,i};
        
        u_i = trifp(data_input(j_NM), parameters); % Triangular membership function values
        
        m = 2; % fuzzification degree of clusters
        u_i_m = u_i^m; % Second term of Equation 8
        
        if ini == 1 % if first iteration
            NM(j_NM).N_i(i) = u_i_m; % Equation 9
            
            NM(j_NM).mu_i(i) = mu_i_ant; % Equation 8
           
        else
            
            NM(j_NM).N_i(i) = N_i_ant + u_i_m; % Equation 9
            NM(j_NM).mu_i(i) = mu_i_ant + ( (data_input(j_NM) - mu_i_ant )/NM(j_NM).N_i(i) ) * u_i_m; % Equation 8
            
            M_i_j(i) = exp( -1/2*( data_input(j_NM) - NM(j_NM).mu_i(i) ) * ( data_input(j_NM) - NM(j_NM).mu_i(i) ) ); % Novelty measurement - Equation 7
            
        end
        
    end
    
    M(j_NM) = max(M_i_j); % Maximum of Novelty measurement - Equation 10
    
end

ini = 0; % Change Flag ini

end % NoveltyMeasuring