dat = readMat('ps3_realdata.mat')
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
dim(vecs)
labels = rep(1:8, each = 91) 
rownames(vecs) <- paste(labels)
nlab = 8
# testing data
test_vecs = matrix(nr =length(dat$test.trial)/2, nc = neur) 
for (i in seq(2,length(dat$test.trial),2)){
  test_vecs[i/2,] = rowSums(dat$test.trial[i][[1]][,351:550]) 
}

dim(vecs)
length(labels)

728/8

#tr_dist <- dist(vecs[91*1:8, ])
tr_dist <- dist(vecs)
res_h <- hclust(tr_dist)
names(res_h)
plot(res_h)
res_h$order

names(res_h)
res_h$order

cols <- rainbow(8)
for (i in 1:8) {
  xs <- which(labels[res_h$order] == i)
  ys <- rep(min(res_h$height), length(xs))
  points(xs, ys, pch = '*', col=cols[i])
}

shared_fit = gauss_fit(vecs, nlab, shared = TRUE)

isqrtm <- function(m) {
  res <- eigen(m)
  d <- res$values
  d[d < 0] <- 0
  d[d > 0] <- 1/sqrt(d[d > 0])
  v <- res$vectors
  return (v %*% diag(d) %*% t(v))
}

dim(shared_fit$mean)
#mu_dist <- dist(shared_fit$mean)
mu_dist <- dist(shared_fit$mean %*% isqrtm(shared_fit$cov))
res_h <- hclust(mu_dist)
plot(res_h)
