# Charles Zheng
# STAT 312 assignment 1

load("v1_locations.RData")
load("valid_stim.RData")
load("valid_v1.RData")
load("valid_index.RData")
ls()

viewimage <- function(ind) {
    img = valid_stim[ind,]
    image(t(matrix(img,128,128)[128:1,]),col=gray.colors(128))
}


png(paste("img",ind,".png",sep=""),width=128,height=128)
img = valid_stim[ind,]
image(t(matrix(img,128,128)[128:1,]),col=gray.colors(128))

viewimage(4)


dim(v1_locations)
dim(valid_index)
dim(valid_stim)
dim(valid_v1)

block1inds = 1:156
v1.1 = valid_v1[,block1inds]
v1i = as.numeric(valid_index[block1inds])
o = order(v1i)
dim(v1.1)
v1.1[1,]
dim(valid_stim)

i1 = valid_stim[1,]
image(matrix(i1,128,128))
