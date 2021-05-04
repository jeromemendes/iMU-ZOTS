function nrmse_error = nrmse(y_real, y_est)
    %% Description
    % This funcion calcs the normalized root-mean-squared error - NRMSE
    %% Funcion inputs
    % y_real - target output
    % y_est - Estimated output
    %% Function output
    % nrmse_error - normalized root-mean-squared error

%% Normalized root-mean-squared error - NRMSE
rmse_est = sqrt( mse( y_real-y_est ) );

nrmse_error = rmse_est/( max(y_real) - min(y_real) );

end