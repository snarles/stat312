# Data loading ---------
load("/Users/Nora/Desktop/classes/stat312/Ex3/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/feature_train.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/train_resp.RData")


featureAttr <- as.matrix(read.csv(file='/Users/Nora/Desktop/classes/stat312/Ex4/featAttr.csv'))
# load("/Users/Nora/Desktop/classes/stat312/Ex4")

# Choose features ------
# Not sure how to do this so lets plug in random

orient_mask <- (featureAttr[1,] %in% c(1,5))
sum(orient_mask)/length(orient_mask)
level_mask <- (featureAttr[2,] %in% c(4,5,6))
xchoice <- 2 # 1 to 8
ychoice <- 2
conv_x <- floor(featureAttr[3,]/2^(featureAttr[2,] - 1) * 8) # x and y truncated to 1 to 8
conv_y <- floor(featureAttr[4,]/2^(featureAttr[2,] - 1) * 8)

features_mask <- orient_mask & level_mask & (conv_x == xchoice) & (conv_y == ychoice)
sum(features_mask)

wav42 <- wav.pyr[, features_mask]

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
