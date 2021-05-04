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

function [left_MF, right_MF] = LocateMFnearest(MF_center, x)
%% Description
% This function locates the nearest left and right membership functions
% (MFs) to the candidate MF (MF_center)
%% Function inputs
% MF_center - the center value b_{j,i} of the candidate MF
% x - Struct with all parameters of the fuzzy system
%% Function output
% left_MF - index of the nearest left MF
% right_MF - index of the nearest right MF
 

left_MF = 0; % Initialization of the index of the nearest left MF
right_MF = 0;  % Initialization of the index of the nearest right MF

n_rules = size( x.Rules,1 ); % number of rules

for i = 1 : n_rules-1 % For all MFs (rules) (except the last one)
    
    center_MF_now = x.Rules(i,2); % MF center value of the current MF
    
    center_MF_next = x.Rules(i+1,2); % MF center value of the next MF
    
    if MF_center >= center_MF_now && MF_center <= center_MF_next % Found the nearest left and right MFs
        
        left_MF = i; % save the index of the nearest left MF
        
        right_MF = i+1; % save the index of the nearest right MF
        
        break
        
    end
    
end

end % LocateMFnearest