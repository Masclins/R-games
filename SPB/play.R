## ROUTE OF THE FOLDER ##
route <- commandArgs(trailingOnly=TRUE)[1]
##########################

source(paste(route,"Engine.R", sep="/"))

players <- c(getPlayers(paste(route, "players", sep = "/")),
             getPlayers(paste(route, "testPlayers", sep = "/")))


tournament <- playTournament(players)

analyzeResults <- function(results) {
  results <- round(results, digits = 1)
  nPlayers <- nrow(results)
  total <- rowSums(results) / (nPlayers - 1)
  tieBreak <- vector(length = nPlayers)
  for (i in 1:nPlayers) tieBreak[i] <- sum(results[i, ] * total)
  results <- cbind(results, TOTAL = total, TIEBREAK = tieBreak)
  podium <- order(total, tieBreak, decreasing = TRUE)
  results <- results[podium, c(podium, (1:2)+nPlayers)]
  results[,c("TOTAL", "TIEBREAK")] <- round(results[,c("TOTAL", "TIEBREAK")], 2)
  results
}
options(width=160)
print(analyzeResults(tournament$results))
