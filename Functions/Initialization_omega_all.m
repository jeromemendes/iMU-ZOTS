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

function [omega] = Initialization_omega_all(data_x, x)
    %% Description
    % This function initializes with zeros the variable \omega for all dataset
    %% Function inputs
    % data_x - Train dataset of input variable
    % x - Struct with all parameters of the neo-fuzzy
    %% Function output
    % omega - variable \omega initialized for all dataset

%% Variables Definition
n_var = size(data_x, 2); % number of inputs variables
L = size(data_x, 1); % dataset size

%% Initialization of variable \omega
for j = 1:n_var % for all input variables
    
    N = size(x(j).Rules,1); % number of rules of input variable j
    
    for i = 1:N % for all rules
        
        omega(j).Rules = zeros(N, L); % Initialize all values with zeros
        
    end
    
end


end