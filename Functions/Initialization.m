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

function [x] = Initialization(dataTotal_x, per_extra, N, eta)
    %% Description
    % This function initializes the struct x, i.e. the initial parameters
    % (Algorithm 2 Step 1)
    %% Function inputs
    % dataTotal_x - All dataset of input variables
    % per_extra - percentage extra to increase the limits of the universe of
    % discourse of the input variables
    % N - Number of fuzzy rules per input variable
    % eta - threshould to define a minimal distance between MFs (Criterion 2)
    %% Function output
    % x - Struct with all parameters of the fuzzy system

%% Variables Definition
n_var = size(dataTotal_x, 2); % number of inputs variables


%% Initialization of the struct x - Algorithm 2 Step 1
for j = 1:n_var % for all input variables
    
    %% Save Variables Limits - Algorithm 2 Step 1.a
    x(j).Limit = [min(dataTotal_x(:,j))-per_extra*abs(min(dataTotal_x(:,j))) max(dataTotal_x(:,j))+per_extra*abs(max(dataTotal_x(:,j)))]; % Definition of universe of discourses of input variable j
        
    %% Antecedents Design  - Algorithm 2 Step 1.b
    
    x(j).Rules = zeros(N, 4); % Initialize all values with zeros
    
    x(j).tau = (x(j).Limit(1,2) - x(j).Limit(1,1) )/eta;
    
    for i = 1:N % for all rules
        
        if i == 1 % First rule
            
            range = (x(j).Limit(1,2) - x(j).Limit(1,1) ) / ( N - 1 );
            
            x(j).Rules(i,2) = x(j).Limit(1,1); % parameter b_{j,i}
            
            x(j).Rules(i,1) = x(j).Limit(1,1); % parameter a_{j,i}
            
            x(j).Rules(i,3) = x(j).Limit(1,1) + range; % parameter c_{j,i}
            
            
        elseif i == N % Last rule
            
            x(j).Rules(i,2) = x(j).Limit(1,2); % parameter b_{j,i}
            
            x(j).Rules(i,1) = x(j).Limit(1,2) - range; % parameter a_{j,i}
            
            x(j).Rules(i,3) = x(j).Rules(i,2); % parameter c_{j,i}
            
        else % Others rule 
            
            x(j).Rules(i,2) = x(j).Rules(i-1,2) + range; % parameter b_{j,i}
            
            x(j).Rules(i,1) = x(j).Rules(i-1,2); % parameter a_{j,i}
            
            x(j).Rules(i,3) =  x(j).Rules(i,2) + range; % parameter c_{j,i}
            
        end
        
        x(j).Rules(i,4) = 0.0; % consequent parameter
        
    end
    
    x(j).bias_j = 0.0; % bias of model of the input j
    
end

x(1).bias = 0.0; % bias - variable y_0

end