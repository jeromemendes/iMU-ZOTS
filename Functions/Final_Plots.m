%% Train results
figure
plot(y_train)
hold on
plot(data_ytrain)
legend('Estimated - train', 'Target')

%% Test results
figure
plot(y_test)
hold on
plot(data_ytest)
legend('Estimated - test', 'Target')