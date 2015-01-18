%% Load and reshape data
clc;clear;
load('vox100stuff.mat');
load('spm_hrf_01.mat');
HRF=flip(downsample(spm_hrf_01,10)); % downsample HRF
HRF_length=length(HRF);
time=length(vox100s{1});
% concatenate the responses and the indices
Response_Vector=[vox100s{1,1}; vox100s{2,1}; vox100s{3,1}; vox100s{4,1}; vox100s{5,1};...
    vox100s{6,1}; vox100s{7,1}; vox100s{8,1}; vox100s{9,1}; vox100s{10,1}];
seqVal=reshape(seqVal,696*10,1);
clear spm_hrf_01 vox100s

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

%% Part A.B

%% Part A.C
% Calculate an event matrix to replace the image matrix in Part A
event_matrix=zeros(time*10, 130*13);
for i=1:130*13
    event_matrix(i*4,i)=1;
end % Not sure if this is the right matrix for this??
Design_Matrix=HRF_matrix*event_matrix;
alpha_event=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Vector;
clear i Design_Matrix

%% Part A.D
% Use the backgound rate from the first model for the zeros in the event
% matrix
% Calculate an event matrix to replace the image matrix in Part A
event_matrix=zeros(time*10, 130*13);
for i=1:130*13
    event_matrix(1+(i-1)*4,i)=1;
end % Not sure if this is the right matrix for this??
Design_Matrix=HRF_matrix*event_matrix;
alpha_event=(Design_Matrix'*Design_Matrix)\Design_Matrix'*Response_Vector;
clear i Design_Matrix

%% Part A.E

%% Part B.A
residuals=HRF_matrix*image_matrix*alpha_image-Response_Vector;
