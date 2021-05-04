%% This is the Boston Housing dataset, from Lichman M (2013), UCI machine learning repository. http://archive.ics.uci.edu/ml

%% Dataset
Z=load('housing.data'); % load dataset

X=Z(:,1:end-1); % define the inputs data
Y=Z(:,end); % define the output data

% division of the dataset
[trainInd,tmp,testInd] = dividerand(size(Y,1),0.5,0.1,0.5); % divide the dataset randomly  to train and test

data_xtrain = X(trainInd,:); data_ytrain = Y(trainInd,:);% train dataset
data_xtest = X(testInd,:); data_ytest = Y(testInd,:); % test dataset

dataTotal_x = X; dataTotal_y = Y; % full dataset