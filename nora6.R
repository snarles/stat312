# Data and library and source loading ---------

# load libaries and read data
source("gauss_class.R")
source("knn_class.R")
library("R.matlab")
library('mvtnorm')
dat = readMat('ps3_realdata.mat')

# Formatting the data the way we need it ----------

# Just defining some numbers
neur = 97
train_trials = 728
test_trials = 728
nlab = 8

# training data
vecs = matrix(nr =length(dat$train.trial)/2, nc = neur) 
for (i in seq(2,length(dat$train.trial),2)){
  vecs[i/2,] = rowSums(dat$train.trial[i][[1]][,351:550])
  }
labels = rep(1:8, each = 91) 
nlab = 8
# testing data
test_vecs = matrix(nr =length(dat$test.trial)/2, nc = neur) 
for (i in seq(2,length(dat$test.trial),2)){
  test_vecs[i/2,] = rowSums(dat$test.trial[i][[1]][,351:550]) 
}

# Classification: Gaussian generative shared cov--------

# estimate the params
shared_fit = gauss_fit(vecs, nlab, shared = TRUE)

# check the training data
Gauss_SharedCov_Train_Error = sum(gauss_predict(vecs, shared_fit) != labels)/train_trials

# try it out on test data
Gauss_SharedCov_assigned_label = gauss_predict(test_vecs, shared_fit)
Gauss_SharedCov_Test_Error = sum(Gauss_SharedCov_assigned_label != labels)/test_trials

# Classification: Gaussian generative separate covs--------

# estimate the params
shared_fit = gauss_fit(vecs, nlab, shared = FALSE)

# check the training data
Gauss_SeparateCov_Train_Error = sum(gauss_predict(vecs, shared_fit) != labels)/train_trials

# try it out on test data
Gauss_SeparateCov_assigned_label = gauss_predict(test_vecs, shared_fit)
Gauss_SeparateCov_Test_Error = sum(Gauss_SharedCov_assigned_label != labels)/test_trials

# Classification: k nearest-neighbor ---------

# choose k using training data
train = choose_k(vecs, labels)
KNN_Train_Error = train$error

# try it out on test data
KNN_assigned_label = knn_test(test_vecs, vecs, labels, k = train$k)
KNN_Test_Error=sum(KNN_assigned_label != labels)/test_trials # Final test error

# Clustering: ---------
fit <- kmeans(vecs,8)
aggregate(vecs,by=list(fit$cluster),FUN=mean)

# Viz ------------

# KNN works pretty well
plot(jitter(KNN_assigned_label,2), jitter(labels,2), 'col' = 2, 'pch'=19, 'cex'=0.5) # plot confusion
# Gauss with shared is slightly better than KNN
plot(jitter(Gauss_SharedCov_assigned_label,2), jitter(labels,2), 'col' = 3, 'pch'=19, 'cex'=0.5) 
# this one doesn't work!
plot(jitter(Gauss_SeparateCov_assigned_label,2), jitter(labels,2), 'col' = 4, 'pch'=19, 'cex'=0.5) 

# Dimension reduction -----------

S=svd(scale(vecs, center = T, scale = F))
new_dim = 3
new_training_vec <- (vecs %*% S$v)[,1:new_dim]
new_test_vec <- (test_vecs %*% S$v)[,1:new_dim]

# estimate the params
shared_fit = gauss_fit(new_training_vec, nlab, shared = FALSE)

# check the training data
Gauss_SharedCov_Train_Error = sum(gauss_predict(new_training_vec, shared_fit) != labels)/train_trials

# try it out on test data
Gauss_SharedCov_assigned_label = gauss_predict(new_test_vec, shared_fit)
Gauss_SharedCov_Test_Error = sum(Gauss_SharedCov_assigned_label != labels)/test_trials

# Try picking out important neurons using heat map

a <- heatmap(vecs)
neur=15;
important_neurons = a$colInd[1:neur];

# estimate the params
shared_fit = gauss_fit(vecs[,important_neurons], nlab, shared = TRUE)

# check the training data
Gauss_SharedCov_Train_Error = sum(gauss_predict(vecs[,important_neurons], shared_fit) != labels)/train_trials

# try it out on test data
Gauss_SharedCov_assigned_label = gauss_predict(test_vecs[,important_neurons], shared_fit)
Gauss_SharedCov_Test_Error = sum(Gauss_SharedCov_assigned_label != labels)/test_trials

