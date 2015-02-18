# Data loading ---------
load("/Users/Nora/Desktop/classes/stat312/Ex3/wavpyr.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/feature_train.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex3/train_resp.RData")
load("/Users/Nora/Desktop/classes/stat312/Ex4/all_voxel_locations.RData")


featureAttr <- as.matrix(read.csv(file='/Users/Nora/Desktop/classes/stat312/Ex4/featAttr.csv'))
train_resp <- read.csv("/Users/Nora/Desktop/classes/stat312/Ex4/train_resp_all.csv")
train_resp <- t(train_resp[voxel.loc[,3]==11, ])
dim(train_resp)

vl <- voxel.loc[voxel.loc[,3]==11, ]

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
vh <- featureAttr[1, features_mask]

features <- which(features_mask)
vertical_features <-vh==5
horizontal_features <- vh==1

contrast_vec = c(0, -1 * vertical_features + 1 * horizontal_features)

# Fit linear model
library(car)

X = feature_train[, features]

nvoxels <- dim(train_resp)[2]
pvs = numeric(nvoxels)
for (vox in 1:nvoxels) {
  res <- lm(train_resp[, vox] ~ X)
  res2 <- linearHypothesis(res, t(contrast_vec))
  pvs[vox] = res2$'Pr(>F)'[2]
}

sum(pvs < .1)

write.table(pvs, file="pvs.dat")

coords <- vl[pvs < .1, ]
lala <- vl[runif(nvoxels) < .1, ]


plot(vl[,1], vl[,2], col='grey')
points(lala[,1], lala[,2], col='red')
points(coords[,1], coords[,2], col='red')
