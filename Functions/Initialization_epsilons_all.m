
function [epsilons] = Initialization_epsilons_all(data_x, x)
    %% Description
    % This function initializes the struct x, i.e. the initial parameters
    % (Algorithm 2 Step 2)
    %% Function inputs
    % dataTotal_x - All dataset of input variables
    % per_extra - percentage extra to increase the limits of the universe of
    % discourse of the input variables
    % N - Number of fuzzy rules per input variable
    %% Function output
    % x - Struct with all parameters of the neo-fuzzy

%% Variables Definition
n_var = size(data_x, 2); % number of inputs variables
L = size(data_x, 1); % L

%% Initialization of the struct x - Algorithm 2 Step 2
for j = 1:n_var % for all input variables
    
    N = size(x(j).Rules,1);
    
    for i = 1:N % for all rules
        
        epsilons(j).Rules = zeros(N, L); % Initialize all values with zeros
        
    end
    

    
end



end