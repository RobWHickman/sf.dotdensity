# random_round
#
# A function which calculates how many dots each class
# will have for each given shape
#
# credit to Jens von Bergmann for this algo https://github.com/mountainMath/dotdensity/blob/master/R/dot-density.R
#
#' @author
#' Jens von Bergmann, Paul Campbell, Robert Hickman
#' @export

random_round <- function(x) {
  v=as.integer(x)
  r=x-v
  test=runif(length(r), 0.0, 1.0)
  add=rep(as.integer(0),length(r))
  add[r>test] <- as.integer(1)
  value=v+add
  ifelse(is.na(value) | value<0,0,value)
  return(value)
}
