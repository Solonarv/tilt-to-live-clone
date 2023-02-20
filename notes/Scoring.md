## Scores
### Score Calculation
#TODO two counters are kept:
 - combo tracker
 - actual score
when a dot is killed, increment score by (combo tracker), and increment (combo tracker) by 1.
combo tracker resets after some time of no kills

#TODO figure out how to handle multiple dots being killed in the same frame: one-by-one, or increment combo tracker first then add each dot's score?

current state: score = dots killed.

### High Scores
#TODO add high-score tracking

Local high scores (personal best): no checking needed
global high scores: could do no checking, but then cheaters will blow up the scoreboard. howe about replays?
player uploads replay; server runs headless game to calculate score; that gets published

## Replays

### Requirements
Figure out what's needed to make physics sim deterministic (shouldn't be too hard)
make input discrete (per-physics-frame)
record RNG seeds

### File Format
game version/build number
game mode, settings
RNG seeds
inputs (list of 64-bit-float angles)

### Displaying
menu item to load & display a replay file
 - warn if version mismatched
 - while playing, controls: pause, rewind, fast-forward
 - "take over" feature?

### Generating Statistics
make "headless" version of game that just runs replay and outputs final statistics