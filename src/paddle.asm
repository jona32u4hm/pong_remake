SECTION "Paddle Control", ROM0

DEF MAX_PADDLE_VEL EQU %0010_1000
DEF PADDLE_ACCEL     EQU %0000_0100

;movePaddle::
; hl: pointer to P# address in RAM
; a:   xxxx0000 if one x is 1 -> move up
;      0000xxxx if one x is 1 -> move down 
movePaddle:
.moveUp
    push af ; a value used again in .moveDown
    and %11110000
    ; if result is zero were not going up, skip to moveDown
    jr z,.moveDown 
    ; --------- accelerate up ----------
    ld a, [hl] 
    cp ~MAX_PADDLE_VEL ;max negative (upwards) velocity
    ; c set if a <= max      (2's complement has been considered)
    jr c,.moveDown ;no need to accelerate if velocity reached its max

    sub a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a ;save value

.moveDown
    pop af
    and %00001111
    ; if result is zero were not going down, return
    jr z,.break
    ; --------- accelerate down ----------
    ld a, [hl] 
    cp MAX_PADDLE_VEL ;max negative (upwards) velocity
    ; c not set if a >= max
    jr nc, .break ;no need to accelerate if velocity reached its max

    add a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a save value

.break
    
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

