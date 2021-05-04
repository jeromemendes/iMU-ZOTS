%% This is the Boston Housing dataset, from Lichman M (2013), UCI machine learning repository. http://archive.ics.uci.edu/ml

%% Dataset

data_xtrain = gui.Train(:,1:end-1); % define the inputs data train
data_xtest = gui.Test(:,1:end-1); % define the inputs data test

data_ytrain = gui.Train(:,end); % define the output data train
data_ytest = gui.Test(:,end); % define the output data train

dataTotal_x = [data_xtrain; data_xtest ]; dataTotal_y = [data_ytrain; data_ytest]; % full dataset