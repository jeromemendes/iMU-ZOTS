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

%% Clean everything
clc
clear
close all
warning('off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%         Configuration         %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% add path
addpath(genpath('./Functions'));
addpath(genpath('./Dataset'));

%% Configuration of the Dataset
DatasetConfig_manually % Manually dataset definition

%% configuration file
ParametersConfig_noGUI


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%            Method             %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization - Algorithm 3 Steps 2-3
[x_ini] = FAM ( data_ytrain, data_xtrain, limit_it, limit_theta, dataTotal_x, per_extra, 2, eta);

%% Iterative Learning algorithm - iMU-ZOTS algorithm- Algorithm 3 Step 4
[x] = AFAM_ND ( x_ini, data_ytrain, data_xtrain, limit_it, limit_theta, th_M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%            Results            %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Final Train Results
y_train = FinalyModel_C(x, data_xtrain);
error_train = nrmse(data_ytrain, y_train') % normalized root-mean-squared error - NRMSE

%% Final test Results
y_test = FinalyModel_C(x, data_xtest);
error_test = nrmse(data_ytest, y_test') % normalized root-mean-squared error - NRMSE

%% Plots
Final_Plots % Plots of the train and test results
PlotMFs(x) % Plots of the membership functions            
