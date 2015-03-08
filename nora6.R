# Data loading and prep ---------

# load libaries and read data
library("R.matlab")
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

# Classification: Gaussian generative --------


# Classification: k nearest-neighbor ---------
# Choose k using training data
distance <- as.matrix(dist(vecs))
nearest <- matrix(0,train_trials, train_trials)
for (i in 1:train_trials){
  nearest[i,] = sort(distance[i,], index.return = TRUE)$ix
}

assigned_label <- matrix(0, train_trials)
tie_count = matrix(0,100)
errors = matrix(0,100)

for (k in 1:100){
  for (i in 1:train_trials){
    near_labels <- table(as.vector(labels[nearest[i,2:(k+1)]]))
    temp=as.numeric(names(near_labels)[near_labels == max(near_labels)]);
    # randomly break ties
    if (length(temp) > 1){
      tie_count[k] = tie_count[k]+1
      temp = temp[sample(c(1:length(temp)),1)]
    }
    assigned_label[i] = temp;
  }
  errors[k] = sum(assigned_label != labels)
}
# Choose the K with the least number of errors and ties
k <- which.min(tie_count+errors)
train_error = errors[k]/train_trials

# Try out on testing data ----------
temp_matrix <- matrix(0, train_trials+1, neur)
assigned_label <- matrix(0, test_trials)
temp_matrix[1:train_trials, ] <- vecs
tie_count = 0
# For each test trial, find the k nearest training trials, 
# and assign the test trial the label of the majority of its neighbors
for (i in 1:test_trials){
  temp_matrix[train_trials+1,] <- t(as.matrix(test_vecs[i,]))
  distance <- as.matrix(dist(temp_matrix))[train_trials+1,]
  nearest <- sort(distance, index.return = TRUE)$ix 
  near_labels <- table(as.vector(labels[nearest[2:(k+1)]]))
  temp=as.numeric(names(near_labels)[near_labels == max(near_labels)]);
  # randomly break ties
  if (length(temp) > 1){
    tie_count = tie_count+1
    print(length(temp))
    temp = temp[sample(c(1:length(temp)),1)]
  }
  assigned_label[i] = temp;
}
plot(jitter(assigned_label,1), jitter(labels,1))
test_error=sum(assigned_label != labels)/test_trials

# Clustering: ---------


