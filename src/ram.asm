DEF YPOS  EQU 0
DEF XPOS  EQU 1
DEF TILE  EQU 2
DEF FLAGS EQU 3

SECTION "WRAM", WRAM0[$C000]
OAM_Source::
P1OBJ::
    ds 4*4
P2OBJ::
    ds 4*4
Ball::
    ds 4
OAM_Other::
    ds 160 - 9
OAM_Source_END::

Hardware_Variables::

JoyPad:: ds 1

Control_Variables::

;Paddle 1 physics
; uses fixed point between nibbles 
velocityPaddle1:: ds 1
velocityPaddle2:: ds 1
subpixelP1:: ds 1
subpixelP2:: ds 1

