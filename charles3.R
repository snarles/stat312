list.files("Ex3")

setwd("Ex3")
for (f in list.files()) {
  if (substring(f,nchar(f)-4, nchar(f))=="RData") {
    load(f)
  }
}
setwd("..")

n_train = 1750
n_valid = 120
p_features = 10921
m_vox = 15


library(glmnet)

vox_ind = 1
train_fs_ridge = cv.glmnet(feature_train, train_resp[, vox_ind],
                     nfolds = 5, alpha = 0)
train_fs_lasso = cv.glmnet(feature_train, train_resp[, vox_ind],
                           nfolds = 5, alpha = 1)
plot(train_fs)

train_fs_ridge$lambda.1se
train_fs_ridge$lambda.min
train_fs_lasso$lambda.1se
log(train_fs_lasso$lambda.min)

train_fs_lasso_full = glmnet(feature_train, train_resp[, vox_ind],
                             alpha = 1, lambda = seq(exp(-3), exp(-2), .01))
plot(train_fs_lasso_full, xvar="lambda")

plot(coef(train_fs_lasso))
plot(coef(train_fs_lasso_full, s=train_fs_lasso$lambda.min))

beta_see = coef(train_fs_lasso_full, s=-2)