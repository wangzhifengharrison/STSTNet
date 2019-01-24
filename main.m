%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This script is to perform the micro-expression recognition using STSTNet with LOSOCV protocol.
%  Reference:
%  xxxxxxxx
%
%  The files include:
%  1) main.m : Script which trains and tests the STSTNet 
%  2) STSTNet.mat : The STSTNet architecture design
%  3) video442subName.txt : List of subject's name  
%  4) input : Input data (28x28x3) arranged in LOSOCV manner
%
%  Matlab version was written by Sze Teng Liong and was tested on Matlab 2018b
%  If you have any problem, please feel free to contact Sze Teng Liong (stliong@fcu.edu.tw)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen('video442subName.txt');
garbage = textscan(fid,'%s','delimiter','\n');
subName =garbage{1}; 

load ('STSTNet.mat')
opts = trainingOptions('adam', 'InitialLearnRate', 0.00005, 'MaxEpochs', 5, 'MiniBatchSize', 256,'Plots','training-progress');

for nSub = 1:length(subName)
    cd (['input\' , subName{nSub,:}]);
    trainingImages = imageDatastore('u_train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    myNet = trainNetwork(trainingImages, STSTNet,opts);
    cd ('..\..')
    cd (['input\' , subName{nSub,:}])
    testImages = imageDatastore('u_test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    desiredLabels =  testImages.Labels;
    predictedLabels = classify(myNet, testImages);
    cd ('..\..')
end
