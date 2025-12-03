SECTION "Paddle Control", ROM0

;movePaddle::
; hl: pointer to P# address in RAM
; a:   xxxx0000 if one x is 1 -> move up
;      0000xxxx if one x is 1 -> move down 
movePaddle:

    ret 

;updatePaddles::
; reads JoyPad variable
; moves paddle 1 with up & down arrows
; moves paddle 2 with A & B buttons
updatePaddles::
    ; ---------------- for first Paddle ----------------
    ;prepare function parameters
    ld hl, P1
    ld a, [JoyPad]
    and %00001111
    ld b, a
    swap a
    or b
    ; a now contains buttons in this order: %UDLR_UDLR
    and %10000100 ;apply a mask for use in movePaddle
    call movePaddle
    ; ---------------- for second Paddle ----------------
    ;prepare function parameters
    ld hl, P2
    ld a, [JoyPad]
    and %11110000
    ld b, a
    swap a
    or b
    ; a now contains buttons in this order: %StrSelAB_StrSelAB
    and %00100001 ;apply a mask for use in movePaddle
    call movePaddle

    ret 

