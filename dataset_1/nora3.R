# Data and library loading --------------
ptm <- proc.time()
library("glmnet")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/feature_train.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/feature_valid.RData")
plot(load("/Users/Nora/Desktop/classes/stat312/EX3Data/train_resp.RData")
# load("/Users/Nora/Desktop/classes/stat312/EX3Data/train_stim.RData")
load("/Users/Nora/Desktop/classes/stat312/EX3Data/valid_resp.RData")
# load("/Users/Nora/Desktop/classes/stat312/EX3Data/valid_stim.RData")
proc.time()-ptm # This took 13 seconds

# Set a few constants ------------
n_train = 1750
n_valid = 120
n_voxel = 15

# Find the best voxel or else just choose a voxel ------------
# This section took about 15 minutes. I can go ahead and tell you, the voxel is 2.
ptm <- proc.time()

mse <- matrix(NA,n_voxel)

for (voxel in 1:n_voxel){
  print(voxel)
  res <- cv.glmnet(x = feature_train, y = train_resp[,voxel], alpha = 1, type.measure="mse")
  mse[voxel] <- min(res$cvm)
}

hist(mse)
voxel = which.min(mse)

proc.time()-ptm

# Fit model for a selected voxel --------

ptm <- proc.time()
# lasso is alpha = 1, ridge is alpha = 0 
res <- cv.glmnet(x = feature_train, y = train_resp[,voxel], alpha = 1, type.measure="mse")
proc.time()-ptm # takes 40 sec

# Look at model detail -----------------
plot(res)
l <- res$lambda.min
beta_vec <- coef(res, s = l)
plot(beta_vec)

# Look at filters -------
filter <- wav.pyr %*% beta_vec[2:10922] ;
filter <- matrix(filter, nrow=128, byrow=FALSE)
image(Real(filter))

# Look at predictions ----------
y_predict <- predict(res,feature_valid, s = res$lambda.min)

# Scatter plot
plot(y_predict, valid_resp[,voxel])
lines(c(-2,2), c(-2,2))

# Comparison
plot(y_predict, type='o', col='red')
lines(valid_resp[,voxel])