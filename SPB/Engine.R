getPlayers <- function(dir) {
  createPlayer <- function(name, f, deterministic = FALSE) {
    return(list(name = name,
                func = f,
                sharpness = 0,
                history = vector(mode = "character"),
                won = FALSE,
                deterministic = deterministic))
  }
  playerNames <- list.files(dir)
  players <- list()
  for(playerName in playerNames) {
    deterministic <- FALSE
    source(paste(dir, playerName, sep = "/"))
    name <- gsub("\\..*", "", playerName)
    players[[length(players)+1]] <- createPlayer(name, eval(parse(text = name)), deterministic = deterministic)
  }
  return(players)
}

playRound <- function(players) {
  output <- vector(length = 2)
  for (playerId in 1:2) {
    output[playerId] <- players[[playerId]]$func(players[[playerId]]$history, players[[3-playerId]]$history)
    if (!(output[playerId] %in% c("S", "P", "B"))) {
      stop(paste("Player", players[[playerId]]$name, "gave an invalid output:", output[playerId]))
    } else if (output[playerId] == "P" & players[[playerId]]$sharpness == 0) {
      stop(paste("Player", players[[playerId]]$name, "poked with a dull stick"))
    }
  }
  for (playerId in 1:2) players[[playerId]]$history <- c(players[[playerId]]$history, output[playerId])
  for (playerId in 1:2) {
    meSword <- players[[playerId]]$sharpness >= 5
    oppSword <- players[[3-playerId]]$sharpness >= 5
    players[[playerId]]$won <-
      (output[playerId] == "P" &
         (output[3-playerId] == "S" |
            (meSword & (!oppSword | output[3-playerId] == "B"))))
  }
  for (playerId in 1:2) {
    if (output[playerId] == "S") {
      players[[playerId]]$sharpness <- players[[playerId]]$sharpness + 1
    } else if (output[playerId] == "P"){
      players[[playerId]]$sharpness <- players[[playerId]]$sharpness - 1
    }
  }
  
  return(players)
}


playTournament <- function(allPlayers, gamesPerMatch = 1000) {
  
  playMatch <- function(players, n) {
    
    playGame <- function(players) {
      for (round in 1:100) {
        players <- playRound(players)
        if (players[[1]]$won | players[[2]]$won) {
          break;
        }
      }
      winner <- 0
      if (players[[1]]$won) winner <- 1
      if (players[[2]]$won) winner <- 2
      return(list(history = rbind(players[[1]]$history, players[[2]]$history),
                  winner = winner))
    }
    
    match <- list(players = c(players[[1]]$name, players[[2]]$name),
                  outcome = c(0, 0),
                  games = list())
    for (i in 1:n) {
      game <- playGame(players)
      if (game$winner != 0) match$outcome[game$winner] <- match$outcome[game$winner] + 1 / n
      match$games[[length(match$games) + 1]] <- game
    }
    return(match)
  }

  nPlayers <- length(allPlayers)
  tournament <- list(results = matrix(0, nrow = nPlayers, ncol = nPlayers),
                     players = vector(length = nPlayers),
                     matches = list())
  
  for (i in 1:(nPlayers-1)) {
    for (j in (i+1):nPlayers) {
      if (allPlayers[[i]]$deterministic & allPlayers[[j]]$deterministic) {gpm <- 1} else {gpm <- gamesPerMatch}
      match <- playMatch(allPlayers[c(i, j)], gpm)
      tournament$results[i, j] <- match$outcome[1]
      tournament$results[j, i] <- match$outcome[2]
      tournament$matches[[length(tournament$matches)+1]] <- match
    }
  }
  
  for (i in 1:nPlayers) tournament$players[i] <- allPlayers[[i]]$name
  rownames(tournament$results) <- tournament$players
  colnames(tournament$results) <- tournament$players
  
  return(tournament)
}


