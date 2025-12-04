SECTION "Paddle Control", ROM0

DEF MAX_PADDLE_VEL EQU %0010_1000
DEF PADDLE_ACCEL     EQU %0000_0010

;movePaddle::
; hl: pointer to Paddle velocity address in RAM
; a:   xxxx0000 if one x is 1 -> move up
;      0000xxxx if one x is 1 -> move down 
movePaddle:
    ld b, a
.moveUp
    and %11110000
    ; if result is zero were not going up, skip to moveDown
    jr z,.moveDown 
    ; --------- accelerate up ----------
    ld a, [hl] 
    dec a
    cp ~MAX_PADDLE_VEL ;max negative (upwards) velocity
    ; c set if a <= -max      (2's complement has been considered)
    jr c,.moveDown ;no need to accelerate if velocity reached its max

    sub a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a ;save value

.moveDown
    ld a, b
    and %00001111
    ; if result is zero were not going down, return
    jr z,.break
    ; --------- accelerate down ----------
    ld a, [hl] 
    cp MAX_PADDLE_VEL ;max negative (upwards) velocity
    ; c not set if a >= max
    jr nc, .break ;no need to accelerate if velocity reached its max

    add a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a ;save value

.break
    ld a, b
    cp 0
    ret nz ;return if input
    ;otherwise, since there's no input we must apply friction
    ld a, [hl]
    cp 0 
    ret z ;if zero, there's no movement nor need to apply friction
    ld b, a; save value
    and %1000_0000 ;if this is not zero then we got ourselves a negative number
    jr z, .negativeFriction ;if a > 0, friction is negative

; ------- positive friction --------
.positiveFriction
    ld a, b;retrieve value
    add a, PADDLE_ACCEL
    jr nc, .loadNewVelocity ;return if still missing friction
    ld a, 0 ;assign 0 vel if not
    jr .loadNewVelocity


; ------- negative friction --------
.negativeFriction
    ld a, b;retrieve value
    sub a, PADDLE_ACCEL ; c flag set if A < PADDLE_ACCEL 
    jr nc, .loadNewVelocity ;return if still missing friction
    ld a, 0 ;assign 0 vel if not
    jr .loadNewVelocity


.loadNewVelocity
    ld [hl],a ;save new velocity
    ret

;updatePaddles::
; reads JoyPad variable
; moves paddle 1 with up & down arrows
; moves paddle 2 with A & B buttons
updatePaddles::
    ; ---------------- for first Paddle ----------------
    ;prepare function parameters
    ld hl, velocityP1
    ld a, [JoyPad]
    and %11110000
    ld b, a
    swap a
    or b
    ; a now contains buttons in this order: %DULR_DULR
    and %01001000 ;apply a mask for use in movePaddle
    call movePaddle
    ; ---------------- for second Paddle ----------------
    ;prepare function parameters
    
    ld hl, velocityP2
    ld a, [JoyPad]
    and %00001111
    ld b, a
    swap a
    or b
    ; a now contains buttons in this order: %StrSelBA_StrSelBA
    and %00010010 ;apply a mask for use in movePaddle
    call movePaddle


    ; --------------- update positions ----------------
;paddle 1
    ld a, [subpixelP1] ;get subpixel part of P1 Y position
    ld l, a
    ld a, [P1OBJ + YPOS] ;get pixel part of P1 Y position
    ld h, a
    ld a, [velocityP1]
    swap a
    ld b, a
    and $F0 ;higher nibble is subpixel velocity
    ld e, a
    ld a, b
    and $0F ;lower nibble is pixel unit velocity
    ld d, a
    add hl, de
    ;save values:
    ld a, l
    ld [subpixelP1], a ;save subpixel part of P1 Y position
    ld a, h
    ld [P1OBJ + YPOS], a ;save pixel part of P1 Y position
;paddle 2
    ld a, [subpixelP2] ;get subpixel part of P1 Y position
    ld l, a
    ld a, [P2OBJ + YPOS] ;get pixel part of P1 Y position
    ld h, a
    ld a, [velocityP2]
    swap a
    ld b, a
    and $F0 ;higher nibble is subpixel velocity
    ld e, a
    ld a, b
    and $0F ;lower nibble is pixel unit velocity
    ld d, a
    add hl, de
    ;save values:
    ld a, l
    ld [subpixelP2], a ;save subpixel part of P1 Y position
    ld a, h
    ld [P1OBJ + YPOS], a ;save pixel part of P1 Y position

    ret 

