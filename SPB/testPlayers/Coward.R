Coward <- function(h1, h2){
  if(sum(h1 == "S") - sum(h1 == "P") >= 5) return("P")
  oppSharpness <- sum(h2 == "S") - sum(h2 == "P")
  if(oppSharpness == 0 | oppSharpness >= 5) return("S")
  return("B")
}

deterministic <- TRUE