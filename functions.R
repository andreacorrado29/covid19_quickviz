# functions.R

# function to produce non parametric smooth line with span parameter "span"
smooth_line <- function(y, span = .5){
  x <- 1:NROW(y)
  predict(loess(y~x, span = span))
}