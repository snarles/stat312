%% Load and reshape data
clc;clear;
load('vox100stuff.mat');
load('spm_hrf_01.mat');
a=downsample(spm_hrf_01,10);
HRF=a(end:-1:1); % downsample HRF
HRF_length=length(HRF);
time=length(vox100s{1}(25:end));
% concatenate the responses and the indices
Response=[vox100s{1,1}(25:end); vox100s{2,1}(25:end); vox100s{3,1}(25:end); vox100s{4,1}(25:end); vox100s{5,1}(25:end);...
    vox100s{6,1}(25:end); vox100s{7,1}(25:end); vox100s{8,1}(25:end); vox100s{9,1}(25:end); vox100s{10,1}(25:end)];
seqVal=reshape(seqVal(25:end,:),time*10,1);

clear spm_hrf_01 vox100s a

%% Make HRF matrix
HRF_matrix_temp=zeros(time, time+HRF_length);
for i=1:time
   HRF_matrix_temp(i,i:(i+HRF_length-1))=HRF;
end
a=HRF_matrix_temp(:,(HRF_length-1):(end-2));
HRF_matrix=blkdiag(a,a,a,a,a,a,a,a,a,a);
clear i a HRF_matrix_temp HRF HRF_length

%% Part A.A
% Now the image part of the design matrix
image_matrix=zeros(time*10,121);
for i=1:time*10
    if seqVal(i)==0
        image_matrix(i,121)=1;
    else
        image_matrix(i,seqVal(i))=1;
    end
end
% Calculate full design matrix, find least squares estimate
Design_Matrix=HRF_matrix*image_matrix;
alpha_image=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response;
e_image=Design_Matrix*alpha_image-Response;

figure; stem(e_image); title('Image Model Residuals');

clear i Design_Matrix

%% Part A.C
% Calculate an event matrix to replace the image matrix in Part A
event_matrix=zeros(time*10, 130*12+120);
for i=1:130*12+120
    event_matrix(i*4,i)=1;
end
Design_Matrix=HRF_matrix*event_matrix;
alpha_event=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response;
e_event=Design_Matrix*alpha_event-Response;

figure; scatter(seqVal(1:4:end),alpha_event)
title('Event Amplitudes for each image');
figure; stem(e_event); title('Event Model Residuals');

clear i Design_Matrix

%% Part A.E
% Fit loess to each block
Response_smooth=zeros(time*10,1);
idx=1:672;
for i=1:10
    Response_smooth(idx) = smooth(Response(idx), 0.8, 'loess');
    idx=idx+672;
end

plot(Response);
hold on; plot(Response_smooth,'r')
title('Global Trends');

% Get rid of global trends
Response_Loess=Response-Response_smooth;

% Compare correlation structure
figure; 
plot(xcorr(Response,'none'));
hold on;
plot(xcorr(Response_Loess,'none'),'r');
title('Cross Correlation')
legend('Original model', 'Loess model');

clear i idx Response_smooth

%% Refit A.A
Design_Matrix=HRF_matrix*image_matrix;
alpha_image_loess=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Loess;
e_image_loess=Design_Matrix*alpha_image_loess-Response_Loess;

% Compare residuals
figure;
plot(e_image)
hold on; plot(e_image_loess,'r')
title('Residuals for Image Model')
legend('Original model', 'Loess model');

clear Design_Matrix

%% Refit A.C
Design_Matrix=HRF_matrix*event_matrix;
alpha_event_loess=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Loess;
e_event_loess=Design_Matrix*alpha_event_loess-Response_Loess;

% Compare residuals
figure;
plot(e_event)
hold on; plot(e_event_loess,'r')
title('Residuals for Event Model')
legend('Original model', 'Loess model');

% Compare images
figure;
scatter(seqVal(1:4:end),alpha_event); hold on;
scatter(seqVal(1:4:end),alpha_event_loess,'r');
title('Event Amplitudes for each image');
legend('Original model','Loess model');

clear Design_Matrix

