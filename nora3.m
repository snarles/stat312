%% Load Data
files=dir('EX3Data');
for i=3:length(files)
    filename=files(i).name;
    disp(['Loading ' filename])
    if ~strcmp(filename(1),'.') && strcmp(filename(end-2:end), 'csv')
        eval([filename(1:end-4) '= csvread(''EX3Data/' filename ''',1,0);'])
    end
    
end

%% Set up training and testing data
A_train=feature_train(1:1500,:);
A_test=feature_train(1501:end,:);

%%
for voxel=1:1
    
    % Define training and testing
    Y_train=train_resp(1:1500,voxel);
    Y_rec=train_resp(1501:end,voxel);
    
    % Least norm solution
    X=A_train'/(A_train*A_train') * Y_train;
    % X=(A_train'*A_train)\ A_train' * Y_train;
    
    %Filter=reshape(X, 128, 128);
    %figure(1); imagesc(Filter); axis image; colormap gray; axis off
    
    Y_model=A_test*X;
    voxel
    norm(Y_model-Y_rec)
    
end
