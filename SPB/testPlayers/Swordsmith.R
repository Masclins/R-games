Swordsmith <- function(h1, h2) {
  mySharpness <- sum(h1 == "S") - sum(h1 == "P")
  oppSharpness <- sum(h2 == "S") - sum(h2 == "P")
  oppLastMove <- if (length(h2) == 0) {""} else {h2[length(h2)]}
  if (mySharpness == 5) return("P")
  if (oppSharpness == 0 | oppLastMove == "B") return("S")
  return("B")
}

deterministic <- TRUE