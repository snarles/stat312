test <- x$test
if (!is.null(x$P) && SSP) {
  P <- x$P
  cat("\n Response transformation matrix:\n")
  attr(P, "assign") <- NULL
  attr(P, "contrasts") <- NULL
  print(P, digits = digits)
}
if (SSP) {
  cat("\nSum of squares and products for the hypothesis:\n")
  print(x$SSPH, digits = digits)
}
if (SSPE) {
  cat("\nSum of squares and products for error:\n")
  print(x$SSPE, digits = digits)
}
if ((!is.null(x$singular)) && x$singular) {
  warning("the error SSP matrix is singular; multivariate tests are unavailable")
  return(invisible(x))
}
SSPE.qr <- qr(x$SSPE)
eigs <- Re(eigen(qr.coef(SSPE.qr, x$SSPH), symmetric = FALSE)$values)
tests <- matrix(NA, 4, 4)
rownames(tests) <- c("Pillai", "Wilks", "Hotelling-Lawley", 
                     "Roy")
if ("Pillai" %in% test) 
  tests[1, 1:4] <- Pillai(eigs, x$df, x$df.residual)
if ("Wilks" %in% test) 
  tests[2, 1:4] <- Wilks(eigs, x$df, x$df.residual)
if ("Hotelling-Lawley" %in% test) 
  tests[3, 1:4] <- HL(eigs, x$df, x$df.residual)
if ("Roy" %in% test) 
  tests[4, 1:4] <- Roy(eigs, x$df, x$df.residual)
tests <- na.omit(tests)
ok <- tests[, 2] >= 0 & tests[, 3] > 0 & tests[, 4] > 0
ok <- !is.na(ok) & ok
tests <- cbind(x$df, tests, pf(tests[ok, 2], tests[ok, 3], 
                               tests[ok, 4], lower.tail = FALSE))
colnames(tests) <- c("Df", "test stat", "approx F", "num Df", 
                     "den Df", "Pr(>F)")
tests <- structure(as.data.frame(tests), heading = paste("\nMultivariate Test", 
                                                         if (nrow(tests) > 1) 
                                                           "s", ": ", x$title, sep = ""), class = c("anova", 
                                                                                                    "data.frame"))
print(tests, digits = digits)
invisible(x)
