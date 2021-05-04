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

function [] = PlotMFs(x, range, resolution)
    %% Description
    % This function presents the plots of the membership functions of all
    % input variables
    %% Function inputs
    % x - Struct with all parameters of the neo-fuzzy
    % range - parameters range to be plotted
    % resolution - resolution of MFs plot

if ~exist('range', 'var') || ~(isequaln(size(range),[1,2]) || isequaln(size(range),[2,1])) ||...
    range(2) > length( x ) || range(1) > range(2)
    % if range does not exist or mismatch, define all parameters
    range = [1 length( x )];
end
if ~exist('resolution', 'var')
    % if resolution does not exist
    resolution = 1000;
end

for j = range(1) : range(2)
    
    figure
    
    n_MFs = size( x(j).Rules,1); % number of MFs for variable j
    
    universe = x(j).Limit(1) : ( x(j).Limit(2)+x(j).Limit(1) )/resolution : x(j).Limit(2); % x axis
    
    
    for i = 1:n_MFs % for each rule of variable j
        
        parameters(1,1) = x(j).Rules(i,1); % parameter a_{j,i};
        parameters(1,2) = x(j).Rules(i,2); % parameter b_{j,i};
        parameters(1,3) = x(j).Rules(i,3); % parameter c_{j,i};
        
        y = trimf(universe, parameters); % Triangular membership function values
        
        plot(universe,y); % plot of the membership function
        hold on;
        labels{i} = strcat('MF ', num2str(i)); % Save legend
        
    end
    
    legend(labels) % Figure legends
    
    title(sprintf('MFs of input variable x_{%d}', j)) % Figure title
    
end

end