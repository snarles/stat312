source("gauss_class.R")
library("R.matlab")
library('mvtnorm')
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

# kmeans

max_K <- 30
results <- list(max_K)
for (i in 1:max_K) {
  results[[i]] <- kmeans(vecs, centers = i)
}
plot(sapply(results, function(v) v$tot.withinss))

K <- 8
res <- results[[K]]
countmat <- matrix(0, 8, K)
for (i in 1:8) {
  countmat[i, ] <- table(c(1:8, res$cluster[labels == i]))-1
}

best_trace <- 0
best_perm <- NULL
for (i in 1:10000) {
  perm <- sample(8, 8, FALSE)
  trr <- sum(diag(countmat[, perm]))
  if (trr > best_trace) {
    best_trace <- trr
    best_perm <- perm
  }
}

default_options <- options()
old_par <- par()
library(corrplot)
corrplot(countmat[, best_perm], is.corr=FALSE)
options(default_options)
par(old_par)

dmat <- as.matrix(tr_dist)
res <- svd(dmat)
plot(res$d[1:10])
plot(res$u[, 2], res$u[, 3], col = rainbow(8)[labels])



tr_dist <- dist(t(vecs))
res_h <- hclust(tr_dist)
names(res_h)
plot(res_h)
res_h$order

heatmap(vecs, Rowv = NA)
?heatmap

heatmap(matrix(rnorm(16), 4, 4))
locator(1)
locator(1)
