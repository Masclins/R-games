Aczino <- function(godToni,rival){
	#block[1]
	#sharp[2]
	#poke[3]

	getGameStatus <- function(gamevector){

		n <- length(gamevector)
		m <- matrix(0,nrow = 3,ncol = n)

		for(i in 1:n){
			# Row 1 "Block"
			if( gamevector[i] == "B" ){
				m[1,i] <- 1
			}else if( gamevector[i] == "S" ){
				#Row 2 "Sharp"
				m[2,i] <- 1
			}else{
				#Row 3 "Poke"
				m[3,i] <- 1
			} 	 	 	 	 	 
		}  

		return(m)
	}

	if( length(godToni) == 0 ) {
		return("S")
	}

	n_rival <- length(rival)
	n_toni <- length(godToni)

	m_toni <- getGameStatus(godToni)
	m_rival <- getGameStatus(rival)

	timesPB <- 0
	timesBP <- 0
	timesPP <- 0

	for(i in 1:ncol(m_toni)){

		if( m_toni[3,i] == 1 && m_rival[1,i] == 1 ){
			timesPB <- timesPB + 1
		}else if( m_toni[1,i] == 1 && m_rival[3,i] == 1){
			timesBP <- timesBP + 1
		}else if( m_toni[3,i] ==1 && m_rival[3,i] == 1){
			timesPP <- timesPP + 1
		}
	}

	damageToni <- rowSums(m_toni)[2] - timesPB - timesPP
	damageRival <- rowSums(m_rival)[2] - timesBP - timesPP

	if(damageToni == 0){
		if(damageRival == 0){
			return("S")
		}else{
			return(sample(c("S","B"),prob=c(0.2,0.8),size=1))
		}
	}	

	if(length(godToni) > 3){
		rivalProbs <- prop.table(table(rival))
		pBlockrival <- rivalProbs["B"]
		pSharprival <- rivalProbs["S"]
		pPokerival <- rivalProbs["P"]

		if( is.na(pBlockrival) ) pBlockrival = 0
		if( is.na(pSharprival) ) pSharprival = 0
		if( is.na(pPokerival) ) pPokerival = 0

		if( pBlockrival > 0.7 ){
			if( pSharprival >= pPokerival ){
				return("S")
			}
			if( pSharprival < pPokerival ){
				return("P")
			}
		}else{
			if( pSharprival >= pPokerival ){
				return("P")
			}

			if( pSharprival < pPokerival ){
				return("B")
			}

		}
	}

	return(sample(c("S","B","P"),prob=c(0.15,0.70,0.15),size=1))

}

deterministic <- FALSE

