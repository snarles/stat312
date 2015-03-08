# Data loading and prep ---------

# load libaries and read data
library("R.matlab")
library('mvtnorm')
dat = readMat('ps3_realdata.mat')

# Sum up the # of spikes in the relevant time frame for each trial 
neur = 97
train_trials = 728
test_trials = 728

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

nlab = 8; 

# Calculate the means of each class
G_means = matrix(nr = nlab, nc = neur) 
for (i in 1:nlab){
  G_means[i,] = colMeans(vecs[labels==i,])
}

# Calculate the shared covariance
G_cov = matrix(0,97,97)
for (i in 1:train_trials){
  G_cov = G_cov+(vecs[i,]-G_means[labels[i],])%*%t(vecs[i,]-G_means[labels[i],])
}
G_cov = G_cov/ train_trials

# try it out on training data
assigned_label <- matrix(0, train_trials)
for (i in 1:train_trials){
  prob = 0
  for (class in 1:nlab){
    prob_temp = dmvnorm(vecs[i,], mean = G_means[class,], sigma = G_cov)
    if (prob_temp > prob){
      prob = prob_temp
      assigned_label[i] = class
    }
  }
}
Gauss_SharedCov_Train_Error = sum(assigned_label != labels)/train_trials

# try it out on testing data
Gauss_SharedCov_assigned_label <- matrix(0, test_trials)
for (i in 1:test_trials){
  prob = 0
  for (class in 1:nlab){
    prob_temp = dmvnorm(test_vecs[i,], mean = G_means[class,], sigma = G_cov)
    if (prob_temp > prob){
      prob = prob_temp
      Gauss_SharedCov_assigned_label[i] = class
    }
  }
}
Gauss_SharedCov_Test_Error = sum(Gauss_SharedCov_assigned_label != labels)/test_trials

# Classification: Gaussian generative separate covs--------

nlab = 8;

# Calculate the means of each class
G_means = matrix(nr = nlab, nc = neur) 
for (i in 1:nlab){
  G_means[i,] = colMeans(vecs[labels==i,])
}

# Calculate the covariance of each class
G_cov = array(0,dim=c(nlab,97,97))
for (i in 1:train_trials){
  G_cov[labels[i],,] = G_cov[labels[i],,]+(vecs[i,]-G_means[labels[i],])%*%t(vecs[i,]-G_means[labels[i],])
}
#G_cov = G_cov/91

# try it out on training data------
assigned_label <- matrix(0, train_trials)
for (i in 1:1){#train_trials){
  prob = 0
  for (class in 1:nlab){
    prob_temp = dmvnorm(vecs[i,], mean = G_means[class,], sigma = G_cov[class,,])
    print(prob_temp)
    if (prob_temp > prob){
      prob = prob_temp
      assigned_label[i] = class
    }
  }
}
Gauss_SeparateCov_Train_Error = sum(assigned_label != labels)/train_trials

# try it out on testing data------
Gauss_SeparateCov_assigned_label <- matrix(0, test_trials)
for (i in 1:test_trials){
  prob = 0
  for (class in 1:nlab){
    prob_temp = dmvnorm(test_vecs[i,], mean = G_means[class,], sigma = G_cov[class,,])
    if (prob_temp > prob){
      prob = prob_temp
      Gauss_SeparateCov_assigned_label[i] = class
    }
  }
}
Gauss_SeparateCov_Test_Error = sum(Gauss_SeparateCov_assigned_label != labels)/test_trials

# Classification: k nearest-neighbor ---------

# Choose k using training data
distance <- as.matrix(dist(vecs)) # calculate distances
nearest <- matrix(0,train_trials, train_trials) 
for (i in 1:train_trials){
  nearest[i,] = sort(distance[i,], index.return = TRUE)$ix # figure out nearest other points
}
assigned_label <- matrix(0, train_trials)
tie_count = matrix(0,100)
errors = matrix(0,100)
for (k in 1:100){
  for (i in 1:train_trials){
    near_labels <- table(as.vector(labels[nearest[i,2:(k+1)]])) # take k nearest points
    temp=as.numeric(names(near_labels)[near_labels == max(near_labels)]); # majority vote
    if (length(temp) > 1){
      tie_count[k] = tie_count[k]+1
      temp = temp[sample(c(1:length(temp)),1)] # if there's a tie, randomly break it
    }
    assigned_label[i] = temp;
  }
  errors[k] = sum(assigned_label != labels) # calculate error rate
}
# Choose the K with the least number of errors and ties
k <- which.min(tie_count+errors)
KNN_Train_Error = errors[k]/train_trials # Final train error

# Try out on test data
temp_matrix <- matrix(0, train_trials+1, neur)
KNN_assigned_label <- matrix(0, test_trials)
temp_matrix[1:train_trials, ] <- vecs
tie_count = 0
for (i in 1:test_trials){
  temp_matrix[train_trials+1,] <- t(as.matrix(test_vecs[i,]))
  distance <- as.matrix(dist(temp_matrix))[train_trials+1,] # calculate the distance to training points
  nearest <- sort(distance, index.return = TRUE)$ix # find k nearest training points 
  near_labels <- table(as.vector(labels[nearest[2:(k+1)]])) 
  temp=as.numeric(names(near_labels)[near_labels == max(near_labels)]); # majority vote
  if (length(temp) > 1){
    tie_count = tie_count+1
    temp = temp[sample(c(1:length(temp)),1)] # randomly break ties
  }
  KNN_assigned_label[i] = temp;
}
KNN_Test_Error=sum(KNN_assigned_label != labels)/test_trials # Final test error

# Clustering: ---------
fit <- kmeans(vecs,8)
aggregate(vecs,by=list(fit$cluster),FUN=mean)

# Viz
plot(jitter(KNN_assigned_label,2), jitter(labels,2), 'col' = 2, 'pch'=19, 'cex'=0.5) # plot confusion
points(jitter(Gauss_SharedCov_assigned_label,2), jitter(labels,2), 'col' = 3, 'pch'=19, 'cex'=0.5) 
plot(jitter(Gauss_SeparateCov_assigned_label,2), jitter(labels,2), 'col' = 4, 'pch'=19, 'cex'=0.5) 

