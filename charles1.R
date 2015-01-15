# Charles Zheng
# STAT 312 assignment 1

load("v1_locations.RData")
load("valid_stim.RData")
load("valid_v1.RData")
load("valid_index.RData")
ls()

dim(v1_locations)
summary(v1_locations)
# ranges x=24:41, y= 11:29, z=3:18
rel_locations <- apply(v1_locations,2,function(v) {v-min(v)+1})
dim(rel_locations)
summary(rel_locations)
rel_x = rel_locations[,1]
rel_y = rel_locations[,2]
rel_z = rel_locations[,3]
# dimensions 18 x 19 x 16
dim(valid_index) # NULL
dim(valid_stim) # 120 x .16384
dim(valid_v1) # 1331 x 1560

0

#write the png files

if (FALSE) {
    library(png)
    for (ind in 1:120) {
        fname = paste("stimuli_images/img",ind,".png",sep="")
        img = valid_stim[ind,]+.5
        img[img > 1]=1
        img[img < 0]=0
        img=matrix(img,128,128)
        writePNG(img,fname)
    }
}
# returns a smaller table, with dimension ?? x 13
# the entire table contains the response to one image
#                          (or set of images, considered identical)
# and only for a particular slice of the brain
# the row can be reformatted into a matrix for visualization
# it includes NAs
extract_slice <- function(slicedim, slicecoord,imageind=1:120) {
    v1dims <- c(18,19,16)
    is = (1:3)[-slicecoord]; is1 = is[1]; is2=is[2]
    sz <- prod(v1dims)/v1dims[slicedim]
    ans <- matrix(NA,sz,13)
    sub1 = valid_v1[,valid_index %in% imageind]
    inds = which(v1_locations[,slicedim]==slicecoord)
    for (ind in inds) {
        i1 = rel_locations[ind,is1]
        i2 = rel_locations[ind,is2]
        targind = i1 + (i2-1)*v1dims[is1]
        ans[targind,] = sub1[ind,]
    }
    return(ans)
}

sub2 <- extract_slice(3,16,3)
image(matrix(sub2[,1],18,19))

slicedim = 1
slicecoord=30
imageind=3

library(rgl)
plot3d(v1_locations[,1],v1_locations[,2],v1_locations[,3])

# part A

vox = valid_v1[100,]
s1 = vox[valid_index==52] # frog
s2 = vox[valid_index==53] # princess
tab <-  data.frame(val = c(s1,s2), stim=c(rep("frog",13),rep("princess",13)))
boxplot(val ~ stim, data=tab)

# compute the t -statistic
tstat <- function(s1,s2) {
    est.var = (sum((s2-mean(s2))^2) + sum((s1-mean(s1))^2))/(12*13)
    est.diff = mean(s1)-mean(s2)
    tstat = est.diff/sqrt(est.var)
    return(tstat)
}
2*(1-pt(abs(tstat(s1,s2)),24))


perm.test <- function(s1,s2) {
# permutation test
    nreps =1000
    ts <- numeric(nreps)
    vals = c(s1,s2)
    for(ii in 1:nreps) {
        inds = sample(26,26)
        s1new = vals[inds[1:13]]
        s2new = vals[inds[14:26]]
        ts[ii] = mean(s1new)-mean(s2new)
    }
    t.original = mean(s1)-mean(s2)
    pv = sum(abs(ts) > abs(t.original))/nreps
    return(pv)
}


perm.test(s1,s2)

nreps = 10
psnull = numeric(nreps)
mu = 0
sigma = 2
for(ii in 1:nreps) {
    psnull[ii] = perm.test(sigma*rnorm(13)+mu,rnorm(13))
}
hist(psnull)

# get receptive field

vox.ind <- 100
                                        # design matrix
dmat <- diag(rep(1,120))[valid_index,]
y <- valid_v1[vox.ind,]
res <- lm(y ~ factor(valid_index))
sr <- summary(res)
pvals <- sr$coefficients[,4]


imglist <- order(pvals)[1:10]
log.p <- -log(pvals[imglist])
require(grDevices)
library(png)
png("plotRF.png",width=1000,height=1000,units="px")
plot(1:10, log.p, main="Receptive field of vox100", cex.main = 2, cex.lab = 2)
for (ii in 1:10) {
    ind <- imglist[ii]
    fname = paste("stimuli_images/img",ind,".png",sep="")
    img = as.raster(readPNG(fname))
    rasterImage(img, ii-.5, log.p[ii]-.5, ii+.5, log.p[ii]+.5, interpolate = FALSE)
}
dev.off()
