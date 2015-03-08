plot2 <- function (x, labels = NULL, hang = 0.1, check = TRUE, axes = TRUE, 
          frame.plot = FALSE, ann = TRUE, main = "Cluster Dendrogram", 
          sub = NULL, xlab = NULL, ylab = "Height", colors = NULL...) 
{
  merge <- x$merge
  if (check) {
    if (!is.matrix(merge) || ncol(merge) != 2) 
      stop("invalid dendrogram")
    if (any(as.integer(merge) != merge)) 
      stop("'merge' component in dendrogram must be integer")
  }
  storage.mode(merge) <- "integer"
  n1 <- nrow(merge)
  n <- n1 + 1L
  height <- as.double(x$height)
  if (check) {
    stopifnot(length(x$order) == n, length(height) == n1)
    if (!identical(sort(merge), c(-(n:1L), +seq_len(n - 2)))) 
      stop("'merge' matrix has invalid contents")
  }
  labels <- if (missing(labels) || is.null(labels)) {
    as.character(if (is.null(x$labels)) seq_len(n) else x$labels)
  }
  else {
    if (is.logical(labels) && !labels) 
      character(n)
    else as.character(labels)
  }
  dev.hold()
  on.exit(dev.flush())
  plot.new()
  graphics:::plotHclust(n1, merge, height, order(x$order), 
                        hang, labels, ...)
  if (axes) 
    axis(2, at = pretty(range(height)), ...)
  if (frame.plot) 
    box(...)
  if (ann) {
    if (!is.null(cl <- x$call) && is.null(sub)) 
      sub <- paste0(deparse(cl[[1L]]), " (*, \"", x$method, 
                    "\")")
    if (is.null(xlab) && !is.null(cl)) 
      xlab <- deparse(cl[[2L]])
    title(main = main, sub = sub, xlab = xlab, ylab = ylab, 
          ...)
  }
  invisible()
}