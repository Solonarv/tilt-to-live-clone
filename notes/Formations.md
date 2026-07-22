## General
#TODO more types

## Types
### Spinning Cross
Five 5x5 blocks of dots arranged in a `+` shape. Spins around its center while moving at constant velocity.

play impact: just generic clutter to dodge. not difficult, but closes off paths for dodging other formations.

### Collapsing Circle
Big circle of loosely-spaced dots that appears centered(ish) on the player, then shrinks while rotating and moving slowly

play impact: must be recognized in time so player can get out between the dots. can lead to very juicy combo kills once the circle has closed.

### Unstable Explosion
#TODO add unstable explosion formation
Tightish cloud of dots that are shaking/vibrating. They suck in loose dots to grow, become more unstable, and also become more unstable over time (shaking more violently). When instability passes a threshold, it explodes, flinging its component dots outward at high velocity (with some variance).

Forms any time too many dots become too close to each other.

play impact: kiting loose dots indefinitely leads to dangerous chaos
### Aimed Arrow
#TODO add aimed arrow formation

wedge- or arrow-shaped formation

appears pointing in random direction, rotates to point toward player, maximum rotation speed

once it's pointing at the player and keeps a lock for (specific time interval) it shoots off toward the player, pretty fast

play impact: must watch the whole screen and pay attention to timing

### Shearing Walls
#TODO add shearing walls formation

walls with gaps that appear on opposite edges of the screen and sweep across it. each wall's dots fit into the other wall's gaps: when they overlap, there is no safe space

### Sweepers
walls that sweep across the entire playing field (horizontally or vertically) with no gaps.

sweepers determine direction randomly, then start on the edge furthest from the player.

small (10%) chance to spawn a mirrored sweeper on the opposite edge as well.

play impact: must reserve some powerups to break through sweepers