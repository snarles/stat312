# Data loading ---------
load("/Users/Nora/Desktop/classes/stat312/Ex3/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/feature_train.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/train_resp.RData")


featureAttr <- read.csv(file='/Users/Nora/Desktop/classes/stat312/Ex4/featAttr.csv')
# load("/Users/Nora/Desktop/classes/stat312/Ex4")

# Choose features ------
# Not sure how to do this so lets plug in random
features <- 0:41
vertical_features <-1:20
horizontal_features <- 21:41

# Fit linear model
X=feature_train[,features]
beta <- solve(t(X)%*%X)%*%t(X)%*%train_resp
verticalness<-colSums(abs(beta[vertical_features,]))
horizontalness<-colSums(abs(beta[horizontal_features,]))
test_statistic=verticalness-horizontalness

# Null distribution should have mean 0, variance = ???
resid <- X %*% beta - train_resp
eps <- mean(diag(var(resid)))
pnorm(test_statistic)
