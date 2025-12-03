
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

P1::
.a      ds 1
.v      ds 1
.state  ds 1
