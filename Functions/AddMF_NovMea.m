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

function  [x, Add, NM] = AddMF_NovMea(x, j, MF_center, left_MF, right_MF, NM, Add)
%% Description
% This function adds a new rule if criteria 1 and 2 are met -  Algorithm 3 Step 4aiiA
%% Function inputs
% x - Struct with all parameters of the fuzzy system
% j - input variable in which can be added a new rule/MF
% MF_center - the center value b_{j,i} of the candidate MF
% left_MF - index of the nearest left MF of the candidate MF
% right_MF - index of the nearest right MF of the candidate MF
% Add - Flag to know if a rule was added

%% Function output
% x - Struct with all parameters of the fuzzy system
% Add - Flag to know if a rule was added
% NM - Struct with the parameters of the Novelty Measuring (NM)


n_rules = size( x(j).Rules,1 ); % Number of rules
tau = x(j).tau; % Variable \eta_j (Criterion 2)

Add(j) = 0; % Flag Add to zero

b_previous = x(j).Rules( left_MF, 2 ); % center value of the nearest left MF
b_next = x(j).Rules( right_MF, 2 ); % center value of the nearest right MF

dist_previous = abs(MF_center - b_previous); % distance beetwen the center of the candidate MF and of the nearest left MF
dist_next = abs(MF_center - b_next); % distance beetwen the center of the candidate MF and of the nearest left MF

if min(dist_previous, dist_next) > tau % condition to Add a new MF (Criteion 2)
    
    Add(j) = 1; % A rule will be added
    
    new_b =  MF_center; % center value of the new MF -  b_{j,i};
    new_left =  x(j).Rules( left_MF, 2 ); % left value of the new MF - a_{j,i};
    new_right =  x(j).Rules( right_MF, 2 ); % right value of the new MF - c_{j,i};
    
    % Change/update in nearest left MF of the new MF
    x(j).Rules( left_MF, 3 ) = new_b;
    
    % Change/update in nearest right MF of the new MF
    x(j).Rules( right_MF , 1 ) = new_b;
    
    % update/sort the Rule Struct (struct x) and NM struct
    for i = n_rules : -1 : right_MF
        
        [x(j).Rules( i+1,:)] = x(j).Rules( i,: );
        
        NM(j).N_i(i+1) = NM(j).N_i(i);
        NM(j).mu_i(i+1) = NM(j).mu_i(i);
    end
    
    %% Insert the new MF
    x(j).Rules(right_MF, 1 ) = new_left; % a_{j,i};
    x(j).Rules(right_MF, 2 ) = new_b;  %  b_{j,i};
    x(j).Rules(right_MF, 3 ) = new_right; %  c_{j,i};
    x(j).Rules(right_MF, 4 ) = 0.0;
    
    %% Initialize the the NM values of the new rule
    NM(j).N_i(right_MF) = 0;
    NM(j).mu_i(right_MF) = 0;
    
end

end % AddMF_NovMea