DEF YPOS  EQU 0
DEF XPOS  EQU 1
DEF TILE  EQU 2
DEF FLAGS EQU 3

export YPOS 
export XPOS 
export TILE 
export FLAGS 

SECTION "WRAM", WRAM0[$C000]
P1OBJ:: 
OAM_Source::
    ds 4*4
P2OBJ::
    ds 4*4
Ball::
    ds 4
OAM_Other::
    ds 160 - 9
OAM_Source_END::

Hardware_Variables:

JoyPad:: ds 1

Control_Variables:
ds 1
;Paddle physics
; uses fixed point between nibbles 
velocityP1:: ds 1
velocityP2:: ds 1
subpixelP1:: ds 1
subpixelP2:: ds 1

ballState:: ds 2
ballCounter:: ds 1

;Ball physics
; uses fixed point between nibbles 
velocityBallY:: ds 1
velocityBallX:: ds 1
subpixelBallX::ds 1
subpixelBallY::ds 1

scoreP1:: ds 1
scoreP2:: ds 1

setUp2Here::

ds 1

launchingPlayer:: ds 1
;score markers. must be next to eachother in ram for setup...
scoreMarkerP1:: ds 4
scoreMarkerP2:: ds 4
;