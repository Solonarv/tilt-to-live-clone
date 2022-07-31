## General
Player inputs a direction and speed to move in and nothing else.

## Modes
### Mouse Control
Player ship tries to be at mouse position, constrained by maximum speed. Short distance = slower movement.

#TODO fancy mouse capture thingy so "mouse cursor is far away from ship" does not happen

### Touch Control
Player moves toward touch location, constrained by maximum speed. Short distance = slower movement.

Currently get this for free as a result of mouse control.

Probably needs to be done explicitly when mouse capture is implemented. Or scrapped. Or reimplemented to deal with multi-touch consistently ( #TODO: how does godot's mouse emulation handle multi-touch?)

### Tilt Control
Player moves in the direction the device is tilted toward. More tilt = faster movement.

#TODO implement tilt control in the first place

#TODO figure out how to calibrate / how to handle different "resting" orientations

### Keyboard Control
classic WASD/arrow-key 8-direction movement. Speed is maximum.

#TODO figure out if this is even desired (prediction: no)

#TODO implement so it can be playtested (should be simple)

### Joystick/gamepad Control
Basically the perfect input method already.

#TODO implement

#TODO find a working joystick to test this with