
SECTION "WRAM", WRAM0[$C000]
OAM_Source::
P1::
    ds 4*4
P2::
    ds 4*4
Ball::
    ds 4
OAM_Other::
    ds 160 - 9
OAM_Source_END::

Hardware_Variables::

JoyPad:: ds 1

Control_Variables::

P1a:: ds 1
P1v:: ds 1

