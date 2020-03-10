Masclans1 <- function(h1, h2) {
  t <- length(h1)
  if (t < 6) {return(c("S","B","P")[(length(h1)%%3)+1])}
  
  mySharpness <- sum(h1 == "S") - sum(h1 == "P")
  if (mySharpness >= 5) {return("P")} else {return("S")}
}

deterministic <- TRUE