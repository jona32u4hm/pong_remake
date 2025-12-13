SECTION "Ball implementation", ROM0

DEF BALL_X_SPEED EQU %00_10_1000

export BALL_X_SPEED

;updateBall::
; moves ball according to velocity variables
; when bouncing of walls, vertical velocity is flipped
; when bouncing off paddles...
;                           paddle velocity is assigned to vertical v.
;                           horizontal velocity is flipped
updateBall::
    ;the ball is a sequential state machine with the following states:
    ;               - launch setup: waits for input, then locates the launching player x position to setup the ball's launching velocity and x position
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

launchingSetup:: 


    ;launchingPlayer will hold a 1 in the LSB for second player or a 0 for first player
    ld a, [launchingPlayer]
    and 1
    jr z,.secondPlayer
.firstPlayer
    ;put ball next to the paddle
    ld a, [P1OBJ + XPOS]
    add TILE_DIMENTION
    ld [Ball + XPOS], a
    ld a, [P1OBJ + YPOS]
    add PADDLE_WIDTH/2 - TILE_DIMENTION/2 
    ld [Ball + YPOS], a

    ;first wait for P1 input
    ld a, [JoyPad]
    and %11110000
    ret z

    ;load positive x speed into the ball
    ld a, BALL_X_SPEED
    ld [ballXSPEED], a
    ;now load the player's shadow OAM address into the launchingPlayer variable
    ld a, low(P1OBJ)
    ld [launchingPlayer], a
    ; update state variable for next time
    ld a, low(moving)
    ld [ballState], a
    ld a, high(moving)
    ld [ballState + 1], a  
ret
.secondPlayer
    ;put ball next to the paddle
    ld a, [P2OBJ + XPOS]
    sub TILE_DIMENTION
    ld [Ball + XPOS], a
    ld a, [P2OBJ + YPOS]
    add PADDLE_WIDTH/2 - TILE_DIMENTION/2 
    ld [Ball + YPOS], a

    ;first wait for P2 input
    ld a, [JoyPad]
    and %00001111
    ret z
    

    ;load negative x speed into the ball (2's complement)
    ld a, - BALL_X_SPEED
    ld [ballXSPEED], a
    ;now load the player's shadow OAM address into the launchingPlayer variable
    ld a, low(P2OBJ)
    ld [launchingPlayer], a
    ;update state variable for next time
    ld a, low(moving)
    ld [ballState], a
    ld a, high(moving)
    ld [ballState + 1], a  
ret

moving::
    ;launchingPlayer holds the (low) shadow OAM address of the player about to launch
    ld a, [launchingPlayer]
    ld l, a
    ld h, high(OAM_Source)
    ld a, [hl]; Get the Y addr of the launching player
    add PADDLE_WIDTH/2 - TILE_DIMENTION/2 
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

counting::
    ;lock launchingPlayer movement:
    ld a, [launchingPlayer]
    ld l, a
    ld h, high(OAM_Source)

    ld bc, 4

    ld a, [Ball + YPOS] ;get ball position
    ;and load the paddle's position accordingly:
    sub PADDLE_WIDTH/2 - TILE_DIMENTION/2 
    ld [hl], a
    add TILE_DIMENTION
    add hl, bc
    ld [hl], a
    add TILE_DIMENTION
    add hl, bc
    ld [hl], a
    add TILE_DIMENTION
    add hl, bc
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
    ;first make the ball reappear:
    ld a, $28
    ld [Ball + TILE], a
    ;update state:
    ld a, low(launching)
    ld [ballState], a
    ld a, high(launching)
    ld [ballState + 1], a
    ret
launching::
    ld hl, velocityP1
    ld a, [launchingPlayer]
    cp low(P1OBJ + 1)
    jr z,.notP2
    ;if we got here the launching player is actually p2
    ld hl, velocityP2
.notP2
    ;now hl holds the velocity address
    ld a, [hl]
    ld [ballYSPEED], a ;load as ball's new speed

    ; now update ball state:
    ld a, low(playing)
    ld [ballState], a
    ld a, high(playing)
    ld [ballState + 1], a
    ret


playing::
    











    
scoring::


    ret