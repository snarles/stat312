%% Load and reshape data
clc;clear;
load('vox100stuff.mat');
load('spm_hrf_01.mat');
a=downsample(spm_hrf_01,10);
HRF=a(end:-1:1); % downsample HRF
HRF_length=length(HRF);
time=length(vox100s{1}(25:end));
% concatenate the responses and the indices
Response_Vector=[vox100s{1,1}(25:end); vox100s{2,1}(25:end); vox100s{3,1}(25:end); vox100s{4,1}(25:end); vox100s{5,1}(25:end);...
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
alpha_image=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Vector;
clear i Design_Matrix

%% Part A.E

% Fit loess to each block
Response_smooth = smooth(Response_Vector, 0.05, 'lowess');
plot(Response_Vector);
hold on; plot(Response_smooth,'r')
Response=Response_Vector-Response_smooth;

% Fit the new model
Design_Matrix=HRF_matrix*image_matrix;
alpha_image_loess=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response;

% Compare residuals
e=HRF_matrix*image_matrix*alpha_image-Response_Vector;
e_loess=HRF_matrix*image_matrix*alpha_image_loess-Response;
plot(e)
hold on; plot(e_loess,'r')

% Compare correlation structure
plot(xcorr(Response_Vector,'unbiased'));
hold on;
plot(xcorr(Response,'unbiased'),'r');

%% Part A.C
% Calculate an event matrix to replace the image matrix in Part A
event_matrix=zeros(time*10, 130*12+120);
for i=1:130*12+120
    event_matrix(i*4,i)=1;
end
Design_Matrix=HRF_matrix*event_matrix;
alpha_event=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Vector;
clear i Design_Matrix
scatter(seqVal(1:4:end),alpha_event)
scatter(seqVal(1:4:end),alpha_event)

%% Part B.A
