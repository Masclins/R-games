Masclans2 <- function(h1, h2) {
  t <- length(h1)
  if (t == 0) return("S")
  if (t == 1) return("B")
  if (t == 2) return("P")
  
  if (t == 4) return("P")
  
  mySharpness <- sum(h1 == "S") - sum(h1 == "P")
  if (mySharpness >= 5) {return("P")} else {return("S")}
}

deterministic <- TRUE