# This contains two functions: gauss_fit, and gauss_predict
# use: 
# fit = gauss_fit(vecs, 8, shared = TRUE)
# assigned_labels = gauss_predict(test_vecs, fit)

# --------------- gauss_fit
gauss_fit = function(train_vecs, nlab, shared = TRUE){
  # training vecs, nrows = trials, ncols = neurons
  # nlab is the number of labels
  # shared is whether or not covariance is shared
  trials = dim(vecs)[1]
  neur = dim(vecs)[2]
  # Calculate the means of each class
  G_means = matrix(nr = nlab, nc = neur) 
  for (i in 1:nlab){
    G_means[i,] = colMeans(vecs[labels==i,])
  }
  # Calculate the covariance
  if (shared){
    G_cov = matrix(0,97,97)
    for (i in 1:train_trials){
      G_cov = G_cov+(vecs[i,]-G_means[labels[i],])%*%t(vecs[i,]-G_means[labels[i],])
    }
    G_cov = G_cov/ train_trials
  } else{
    G_cov = array(0,dim=c(nlab,97,97))
    for (i in 1:train_trials){
      G_cov[labels[i],,] = G_cov[labels[i],,]+(vecs[i,]-G_means[labels[i],])%*%t(vecs[i,]-G_means[labels[i],])
    }
    G_cov = nlab* G_cov/trials
  }
  # return the fit
  return(list("mean" = G_means, "cov" = G_cov))
}
  
# --------------- gauss_predict
gauss_predict = function(test_vecs, fit){
  # vectors to test
  # fit is from above function
  trials = dim(test_vecs)[1]
  nlab = dim(fit$mean)[1]
  assigned_label = matrix(0, trials, 1)
  if (length(dim(fit$cov)) == 3){shared = FALSE} else{shared = TRUE}
  for (i in 1:trials){
    prob = 0
    for (class in 1:nlab){
      if (shared){
        prob_temp = dmvnorm(vecs[i,], mean = fit$mean[class,], sigma = fit$cov)
      } else{
        prob_temp = dmvnorm(test_vecs[i,], mean = fit$mean[class,], sigma = fit$cov[class,,])
      }
      if (prob_temp > prob){
        prob = prob_temp
        assigned_label[i] = class
      }
    }
  }
  return(assigned_label)
}