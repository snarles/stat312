# Data and library loading --------------
library("glmnet")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/feature_train.RData")
# load("/Users/Nora/Desktop/classes/stat312/EX3Data/feature_valid.RData")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/train_resp.RData")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/train_stim.RData")
# load("/Users/Nora/Desktop/classes/stat312/EX3Data/valid_resp.RData")
# load("/Users/Nora/Desktop/classes/stat312/EX3Data/valid_stim.RData")
# Set a few constants ------------
n_train=1750
n_valid=120
# Fit model for a selected voxel --------
voxel=1;

# lasso is alpha = 1, ridge is alpha = 0 
lasso <- cv.glmnet(x = feature_train, y = train_resp[,voxel], alpha = 1)
# Look at model detail -----------------
lasso$lambda.min
plot(lasso)
