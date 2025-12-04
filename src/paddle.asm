SECTION "Paddle Control", ROM0

DEF MAX_PADDLE_VEL EQU %00_10_1000 ; DO NOT USE FIRST 2 BYTES as those are used to detect negative numbers
DEF PADDLE_ACCEL   EQU %00_00_0010
DEF PADDLE_ZERO_OFFSET    EQU 128  ; offset for negative numbers in movePaddle,
                            ; which negative numpers more confortable to
                            ; work with when using c flag...
export PADDLE_ZERO_OFFSET 

;movePaddle::
; hl: pointer to Paddle velocity address in RAM
; a:   xxxx0000 if one x is 1 -> move up
;      0000xxxx if one x is 1 -> move down 
movePaddle:
    ld b, a
.moveUp
    and %11110000
    ; if AND result is zero were not going up, skip to moveDown
    jr z,.moveDown 
    ; --------- accelerate up ----------
    ld a, [hl] 
    cp PADDLE_ZERO_OFFSET - MAX_PADDLE_VEL ;max negative (upwards) velocity
    ; c set if a < -max      
    jr c,.moveDown ;no need to accelerate if velocity reached its max
    sub a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a ;save value

.moveDown
    ld a, b
    and %00001111
    ; if AND result is zero were not going down, skip to break (friction part)
    jr z,.break
    ; --------- accelerate down ----------
    ld a, [hl] 
    cp PADDLE_ZERO_OFFSET + MAX_PADDLE_VEL ;max positive (downwards) velocity
    ; c not set if a >= max
    jr nc, .break ;no need to accelerate if velocity reached its max

    add a, PADDLE_ACCEL ;accelerate upwards
    ld [hl], a ;save value

.break
    ld a, b; retrieve input state
    cp 0 ;no input?
    ret nz ;return if input
    ;otherwise, since there's no input we must apply friction
    ld a, [hl]
    cp PADDLE_ZERO_OFFSET 
    ret z ;if zero, there's no movement nor need to apply friction

    jr nc, .negativeFriction ;if a > 0, friction is negative

; ------- positive friction --------
.positiveFriction
    inc a
    ld [hl],a ;save new velocity
    ret

; ------- negative friction --------
.negativeFriction
    dec a
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
    sub PADDLE_ZERO_OFFSET ;remove ofset

    push af
    ; calculate complement mask to store in b
    and %11000000
    ld b, a
    rr b
    rr b
    or b
    ld b, a
    ; done, B will hold F0 if velocity is negative else 00
    pop af

    swap a
    push af
    and $0F ;lower nibble is pixel unit velocity
    or b ;apply complement mask
    ld d, a ;store in higher byte

    swap b
    pop af
    and $F0 ;higher nibble is subpixel velocity
    or b ;apply complement mask
    ld e, a ;store in lower byte


    ;add velocity 
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
    sub PADDLE_ZERO_OFFSET ;remove offset

    push af
    ; calculate complement mask to store in b
    and %11000000
    ld b, a
    rr b
    rr b
    or b
    ld b, a
    ; done, B will hold F0 if velocity is negative else 00
    pop af

    swap a
    push af
    and $0F ;lower nibble is pixel unit velocity
    or b ;apply complement mask
    ld d, a ;store in higher byte

    swap b
    pop af
    and $F0 ;higher nibble is subpixel velocity
    or b ;apply complement mask
    ld e, a ;store in lower byte


    ;add velocity 
    add hl, de
    ;save values:
    ld a, l
    ld [subpixelP2], a ;save subpixel part of P1 Y position
    ld a, h
    ld [P2OBJ + YPOS], a ;save pixel part of P1 Y position

    ret 

