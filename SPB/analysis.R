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

getPlayerMatches <- function(tournament, player) {
  playing <- sapply(tournament$matches, function(match) {player %in% match$players})
  return(tournament$matches[playing])
}


source("~/games/SPB/tournament.R")
analyzeResults(tournament$results)