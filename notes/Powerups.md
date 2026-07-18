## General
### Spawning
Powerups have a 2% chance to spawn every 0.2s, accumulating (i.e. failing this chance increases the chance by 2%).

Unused powerups provide a chance for spawning to fail, equal to `0.5^(powerups/4)`.

#TODO more types

## Types
### Explosion
when touched, turns into a stationary fireball for 1 second. any enemies that touch it are incinerated.

### Explodey Shield

when touched, gives the player a shield. when the shield touches an enemy, the shield explodes, leaving a stationary fireball for 1 second.

### Phasing Bomb
gain phasing (don't collide with enemies) for X seconds, leaving a trail. when phasing ends, explosion races along the trail.

### Wave Motion Gun
#TODO implement wave motion gun

when touched, player starts charging up. After 1 second, fires a big wave of energy in the direction player is facing that incinerates enemies.

### Uno Reverse Card
#TODO implement uno reverse card

gives player a buff for X seconds. while active, if player collides with enemy, the enemy dies and the player does not.

### Missiles
#TODO implement missiles

spawns some number of missiles that seek out concentrations of enemies where they explode leaving a stationary fireball for fractions of a second