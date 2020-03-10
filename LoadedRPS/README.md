# LoadedRPS

A game based on [LoadedRPS](https://codegolf.stackexchange.com/questions/122376/koth-loaded-rps) from codegolf.SE


# Game Rules

The game is a simple "Rock-Paper-Scissors" with a twist: Points gained with each victory increases during the match (your R, P or S get loaded).

 - Paper wins Rock
 - Scissors wins Paper
 - Rock wins Scissors

The winner gets as many points as the load on his play.

The loser increases by 1 the load on his play.

In the case of a tie, each player increases the load on his play by 0.5.

After 100 plays, the one with more points is the winner.

> e.g.: P1 has loads `10,11,12` (Rock, Paper, Scissors) and P2 `7,8,9`. P1 plays `"R"`, P2 plays `"P"`. P2 wins and gets 8 points. P1 loads become `11,11,12`, P2 loads stay the same.

# Challenge specifications
You have to create a function that takes each of these variables as an argument on each execution:

    my_points, opp_points, my_loaded, opp_loaded, my_history, opp_history
`points` - Current points (yours and your opp). 

`loaded`- Numeric vectors with loads (in order RPS) (yours and your opp)

`history`- Character vectors with all plays, last character is the last play (yours and your opp)

You must return `"R"`, `"P"` or `"S"`. If return something different, you're disqualified.

You can upload up to three bots. Do so in `/players/`.
The function and the file it's on should share name:
> e.g. `botName <- function(my_points, opp_points, my_load, opp_load, my_history, opp_history) { ... }` in `/players/botName.R`

If your bot is deterministic (i.e., has no random decision) feel free to add  `deterministic <- TRUE` at the end of your bot's file, so the tournament takes less to execute.

# Winner

The winner will be decided by selecting the person with the most win matches after 1000 full round-robins. Ties will be broken by matches tied.
1000 matches are being played rather than one because I expect a lot of randomness, and that way the randomness would be less relevant.
