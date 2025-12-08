SECTION "Ball implementation", ROM0



;updateBall::
; moves ball according to velocity variables
; when bouncing of walls, vertical velocity is flipped
; when bouncing off paddles...
;                           paddle velocity is assigned to vertical v.
;                           horizontal velocity is flipped
updateBall::
    ;the ball is a sequential state machine with the following states:
    ;               - moving: player can move the paddle and ball to desired position
    ;               - counting: the ball blinks 3x before launching, paddle static
    ;               - launching: a player starts the game by moving a paddle
    ;               - playing: te ball moves arround bouncing off surfaces
    ;               - scoring: the ball disapears and checks who scored. 
    
    ;start by fetching the state
    ld a, [ballState]
    ld l, a
    ld a, [ballState + 1]
    ld h, a
    ;jump to current state routine
    jp hl

moving:
    ;scoringPlayer holds the (low) shadow OAM address of the player about to launch
    ld a, [scoringPlayer]
    ld l, a
    ld h, high(OAM_Source)
    ld a, [hl]; Get the Y addr of the launching player
    add PADDLE_WIDTH/2 + OBJ_Y_OFFSET*TILE_SIZE - TILE_SIZE/2 
    ; A now holds the Y position of the ball 
    ld [Ball + YPOS], a
    ; decrement counter:
    ld a, [ballCounter]
    dec a
    ld [ballCounter],a
    ret nz; return if still not time for next state
    ;if not, update state:
    ld a, low(counting)
    ld [ballState], a
    ld a, high(counting)
    ld [ballState + 1], a

    ; Start counter for next state:
    ld a, %100_0_0000 ;(we need blinking 3 times, which happens at byte 4)
    ;     %010_1_0000
    ;     %010_0_0000
    ;     %001_1_0000
    ;     %001_0_0000
    ;     %000_1_0000
    ;     %000_0_0000
    ;       launch
    ld [ballCounter], a
    ret

counting:
    ;lock scoringPlayer movement:
    ld a, [scoringPlayer]
    ld l, a
    ld h, high(OAM_Source)

    ld a, [Ball + TILE] ;get ball position
    ;and load the paddle's position accordingly:
    sub PADDLE_WIDTH/2 + OBJ_Y_OFFSET*TILE_SIZE - TILE_SIZE/2 
    ld [hl], a
    add TILE_SIZE
    add hl, 4
    ld [hl], a
    add TILE_SIZE
    add hl, 4
    ld [hl], a
    add TILE_SIZE
    add hl, 4
    ld [hl], a

    ;dec counter
    ld a, [ballCounter]
    dec a
    ld [ballCounter], a
    jr z,.startLaunch
    and %000_1_0000
    jr z,.blinkBall ;if zero, we'll load zero as the tile (blank tile)
    ;if not, load ball tile:
    ld a, $28
.blinkBall
    ld [Ball + TILE], a
    ret

; Launch logic: (ROUGHLY)
;   at startLaunch, paddle position is read
;   at launching, paddle position is read once again
;   the difference between this two values is assigned to the ball's speed
;...this means that each frame the ball is moved what the paddle moved 
;between those specific frames
.startLaunch
    ;paddle y is already available from ball y... no need to store it
    ;update state:
    ld a, low(launching)
    ld [ballState], a
    ld a, high(launching)
    ld [ballState + 1], a
    ret
launching:
    ld a, [scoringPlayer]
    ld l, a
    ld h, high(OAM_Source)
    ld a, [hl]; Get the Y addr of the launching player

    add PADDLE_WIDTH/2 + OBJ_Y_OFFSET*TILE_SIZE - TILE_SIZE/2 
    ld b, a
    ld a, [Ball + YPOS]
    sub b
    ; a now holds the difference of paddle position between frames
    ; this is the paddle's average speed
    ld [ballYSPEED], a ;load as ball's new speed

    ; now update ball state:
    ld a, low(playing)
    ld [ballState], a
    ld a, high(playing)
    ld [ballState + 1], a
    ret
playing:
    ; when bouncing off a surface, ballYSPEED is complemented
scoring:


    ret