# Data loading ---------
# load("/Users/Nora/Desktop/classes/stat312/Ex3/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/feature_train.RData")
# load("/Users/Nora/Desktop/classes/stat312/Ex3/train_resp.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex4/all_voxel_locations.RData")

featureAttr <- as.matrix(read.csv(file='/Users/Nora/Desktop/classes/stat312/Ex4/featAttr.csv'))
train_resp <- read.csv("/Users/Nora/Desktop/classes/stat312/Ex4/train_resp_all.csv")
train_resp <- t(train_resp[voxel.loc[,3]==11, ])
dim(train_resp)

vl <- voxel.loc[voxel.loc[,3]==11, ]
library(car)

# Choose features ------

orient_mask <- (featureAttr[1,] %in% c(1,5))
sum(orient_mask)/length(orient_mask)
level_mask <- (featureAttr[2,] %in% c(4,5,6))
xchoice <- 2 # 1 to 8
ychoice <- 2
conv_x <- floor(featureAttr[3,]/2^(featureAttr[2,] - 1) * 8) # x and y truncated to 1 to 8
conv_y <- floor(featureAttr[4,]/2^(featureAttr[2,] - 1) * 8)

features_mask <- orient_mask & level_mask & (conv_x == xchoice) & (conv_y == ychoice)
sum(features_mask)

#wav42 <- wav.pyr[, features_mask]
vh <- featureAttr[1, features_mask]

features <- which(features_mask)
vertical_features <-vh==5
horizontal_features <- vh==1

contrast_vec = c(0, -1 * vertical_features + 1 * horizontal_features)

# Fit linear model -------------
nvoxels=dim(train_resp)[2]
P = numeric(nvoxels)
X = feature_train[, features]
for (vox in 1:nvoxels){
res <- lm(train_resp[,vox] ~ X)
res2 <- linearHypothesis(res, t(contrast_vec))
P[vox]=res2$'Pr(>F)'[2]
}

# Plots ---------------

# "significant p-values"
plot(vl, col='grey')
points(vl[P<0.1,], col='red') # some structure I guess

# Distribution of p-values
hist(P, breaks=100) # relatively uniform except at very small p-values

# P-P plot
plot(1:nvoxels/nvoxels, sort(P))
lines(0:1,0:1)

# Bonferonni -----------
alpha <- 0.1;
p_bon=alpha/nvoxels
plot(vl, col='grey')
points(vl[P<0.1,], col='red') # some structure I guess
points(vl[P<p_bon,],col='green') # soo basically nothing so sad

# BH -------------------
alpha <- 0.1;
for (vox in 1:nvoxels){
  if (sort(P)[vox] > alpha*vox/nvoxels){
    break
  }
}
plot(vl, col='grey', pch=20)
# Just P < 0.1
points(vl[P<0.1,], col='red', pch=20) # some structure I guess
# BH FDR control
points(vl[order(P)[1:15],], col='black', pch='o')
# Bonferonni control
points(vl[P<p_bon,],col='black', pch='|') # soo basically nothing so sad
legend("bottomright",c("No control", "B-H FDR", "Bonferonni"), col=c('red', 'black', 'black'), pch=c('o','o','|'))


# FWE by permutation ---------------
# randomize images by reordering rows of X, the design matrix
nimages=dim(X)[1]
n_repeats=5
P_min_null=numeric(n_repeats)
for (i in 1:n_repeats){
  X_random=X[sample(1:nimages),]
  P_null = numeric(nvoxels)
  for (j in 1:nvoxels){
    res <- lm(train_resp[,j] ~ X_random)
    res2 <- linearHypothesis(res, t(contrast_vec))
    P_null[j]=res2$'Pr(>F)'[2]
  }
  P_min_null[i]=min(P_null)
  print(i)
}
hist(P_min_null,breaks=10)
lines(c(p_bon, p_bon),c(0,3), col='red')
lines(c(alpha*vox/nvoxels, alpha*vox/nvoxels),c(0,3), col='blue')

# Check on Validation Data --------------------------
for (vox in 1:nvoxels){
  res <- lm(train_resp[,vox] ~ X)
  res2 <- linearHypothesis(res, t(contrast_vec))
  P[vox]=res2$'Pr(>F)'[2]
}

