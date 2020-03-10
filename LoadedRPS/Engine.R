getPlayers <- function(dir) {
  createPlayer <- function(name, f, deterministic = FALSE) {
    return(list(name = name,
                func = f,
                score = 0,
                load = rep(1, 3),
                history = vector(mode = "character"),
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

playTournament <- function(allPlayers, gamesPerMatch = 1000) {
  
  playMatch <- function(players, n) {
    
    playGame <- function(players) {
      
      playRound <- function(players) {
        output <- vector(length = 2)
        for (playerId in 1:2) {
          output[playerId] <- players[[playerId]]$func(
            players[[playerId]]$score, players[[3-playerId]]$score,
            players[[playerId]]$load, players[[3-playerId]]$load,
            players[[playerId]]$history, players[[3-playerId]]$history)
          if (!(output[playerId] %in% c("R", "P", "S"))) {
            stop(paste("Player", players[[playerId]]$name, "gave an invalid output:", output[playerId]))
          }
        }
        for (playerId in 1:2) players[[playerId]]$history <- c(players[[playerId]]$history, output[playerId])
        if (output[1] == "R") {
          if (output[2] == "R") {
            for (playerId in 1:2) players[[playerId]]$loaded[1] <- players[[playerId]]$loaded[1] + 0.5
          } else if (output[2] == "P") {
            players[[1]]$loaded[1] <- players[[1]]$loaded[1] + 1
            players[[2]]$score <- players[[2]]$score + players[[2]]$loaded[2]
          } else {
            players[[2]]$loaded[3] <- players[[2]]$loaded[3] + 1
            players[[1]]$score <- players[[1]]$score + players[[1]]$loaded[1]
          }
        } else if (output[1] == "P") {
          if (output[2] == "R") {
            players[[2]]$loaded[1] <- players[[2]]$loaded[1] + 1
            players[[1]]$score <- players[[1]]$score + players[[1]]$loaded[2]
          } else if (output[2] == "P") {
            for (playerId in 1:2) players[[playerId]]$loaded[2] <- players[[playerId]]$loaded[2] + 0.5
          } else {
            players[[1]]$loaded[2] <- players[[1]]$loaded[2] + 1
            players[[2]]$score <- players[[2]]$score + players[[2]]$loaded[3]
          }
        } else {
          if (output[2] == "R") {
            players[[1]]$loaded[3] <- players[[1]]$loaded[3] + 1
            players[[2]]$score <- players[[2]]$score + players[[2]]$loaded[1]
          } else if (output[2] == "P") {
            players[[2]]$loaded[2] <- players[[2]]$loaded[2] + 1
            players[[1]]$score <- players[[1]]$score + players[[1]]$loaded[3]
          } else {
            for (playerId in 1:2) players[[playerId]]$loaded[3] <- players[[playerId]]$loaded[3] + 0.5
          }
        }
        
        return(players)
      }
      
      if (players[[1]]$score > players[[2]]$score) {
        winner <- 1
      } else if (players[[1]]$score > players[[2]]$score) {
        winner <- 2
      } else {
        winner <- 0
      }
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


