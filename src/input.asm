INCLUDE "include/hardware.inc"

SECTION "Input", ROM0



; readJoyPad: 
;   stores JoyPad state in JoyPad WRAM variable
;   a also holds ths value on exit
;   output consists of one byte, were 0 represents pressed and 1 represents nnnnn
readJoyPad::
    ld a,  JOYP_GET_CTRL_PAD
    ld [rJOYP], a
    nop 
    nop ;wait a few cycles
    ld a, [rJOYP] 
    ld a, [rJOYP] 
    ld a, [rJOYP] 
    and $0F ;get only 4 bits
    swap a
    ld  b, a
    ;B now contains DPAD in higher nibble
    ld a,  JOYP_GET_BUTTONS
    ld [rJOYP], a
    nop 
    nop ;wait a few cycles
    ld a, [rJOYP] 
    ld a, [rJOYP] 
    ld a, [rJOYP] 
    and $0F
    or b
    ;A now contains B | A which includes all the jpad buttons
    cpl ; buttons are now 1 when pressed 0 when released
    ld [JoyPad], a
    ret 

