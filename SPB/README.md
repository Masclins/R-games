# SPB
A game based on [Caveman](https://codegolf.stackexchange.com/questions/34968/caveman-duels-or-me-poke-you-with-sharp-stick) from codegolf.SE

## Description
> Caveman need sharp stick to stab other caveman. Other caveman also try to stab with sharp stick. Caveman can sharpen stick, poke with stick, or block poky sticks.
Players are required to create an R function that tells the caveman what to do.

## Input
The function will recieve two character vectors with a history of the events that have happened, where `"S"` stands for sharpen (i.e. the caveman sharpened his stick), `"P"` stands for poke, and `"B"` stands for block. The irst argument will be the player's history, and the second, the opponent's. Therefore, any function needs to accept two arguments (and only two).
On turn 1, the input will be two empty vectors.

## Output
Your program should return `"S"`, `"P"` or `"B"`. Furthermore, it shouldn't return `"P"` when sharpness is 0 (see below). An illegal output will result in disqualification.

## Game Rules
Sharpness starts at 0. A stick with 5 or more sharpness is considered a sword.

- `"S"` - Sharpen:
When sharpening, the caveman's stick's sharpness goes up by 1.

- `"P"` - Poke:
When poking, the caveman's stick's sharpness goes down by 1. If opponent is sharpening, you win. If you poke with a sword and opponent is either blocking, sharpening or poking with a stick, you win.

- `"B"` - Block:
When blocking, you ignore opponent's poke (unless she has a sword!). If your opponent is not poking, block does nothing.

## Upload your functions
You can upload up to a maximum of three functions. Do so in `/players/`.
The function and the file it's on should share name:
> eg: `botName <- function(h1, h2) { ... }` in `/players/botName.R`

If your bot is deterministic (i.e., has no random decision) feel free to add  `deterministic <- TRUE` at the end of your bot's file, so the tournament takes less to execute.

## Run the game
You'll only need to execute the script passing the SPB folder as an argument:
> e.g. `Rscript play.R ~/R-games/SPB` 
