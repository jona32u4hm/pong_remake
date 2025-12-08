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
    ;               - counting: the ball blinks 3x before launching
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
    ret

counting:

launching:

playing:

scoring:


    ret