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

function u_mf = trifp(data_mf, parameters)
%% Description
% This function obtains the fuzzu_mf degree of a triangular MF for a given data

%% Function inputs
% data_mf - data
% parameters - parameters of the triangular MF - parameters = [a b c] which
% are,  the lower limit, center value, and upper limit of the MF,
% respectivelu_mf.

%% Function output
% u_mf - fuzzu_mf degree of a triangular MF

u_mf = 0;

if (data_mf> parameters(1) && data_mf< parameters(2)) % left size
    
    u_mf = (data_mf-parameters(1))/(parameters(2)-parameters(1));
    
elseif (data_mf>= parameters(2) && data_mf< parameters(3)) % right size
    
    u_mf = (parameters(3)-data_mf)/(parameters(3)-parameters(2));
    
elseif (data_mf<= parameters(1) || data_mf>= parameters(3)) % outside
    
    u_mf = 0;
    
end


end