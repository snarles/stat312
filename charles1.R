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

#library(png)
#for (ind in 1:120) {
#    fname = paste("stimuli_images/img",ind,".png",sep="")
#    img = valid_stim[ind,]+.5
#    img=matrix(img,128,128)
#    writePNG(img,fname)
#}

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
