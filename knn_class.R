choose_k = function(vecs, labels){
  train_trials = dim(vecs)[1] # the number of trials
  distance <- as.matrix(dist(vecs)) # calculate distances between trials
  nearest <- matrix(0,train_trials, train_trials) 
  for (i in 1:train_trials){
    nearest[i,] = sort(distance[i,], index.return = TRUE)$ix # figure out nearest other trials
  }
  assigned_label <- matrix(0, train_trials)
  tie_count = matrix(0,100)
  errors = matrix(0,100)
  for (k in 1:100){
    for (i in 1:train_trials){
      near_labels <- table(as.vector(labels[nearest[i,2:(k+1)]])) # take k nearest trials
      temp=as.numeric(names(near_labels)[near_labels == max(near_labels)]); # majority vote
      if (length(temp) > 1){
        tie_count[k] = tie_count[k]+1
        temp = temp[sample(c(1:length(temp)),1)] # if there's a tie, randomly break it
      }
      assigned_label[i] = temp;
    }
    errors[k] = sum(assigned_label != labels) # calculate error rate
  }
  # Choose the K with the least number of errors and ties (which could also easily be errors)
  k = which.min(tie_count+errors)
  return(list("k" = k, "error" = errors[k]/train_trials)) # return the optimal k and its error rate
}

# --------
# test vecs, training vecs, labels, k
knn_test = function(test_vecs, vecs, labels, k = 0){
  if (k==0){
    k = choose_k(vecs, labels)
  }
  train_trials = dim(vecs)[1] # the number of trials
  test_trials = dim(test_vecs)[1] # the number of trials
  neur = dim(vecs)[2]
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
  print(tie_count)
  return(KNN_assigned_label)
}
