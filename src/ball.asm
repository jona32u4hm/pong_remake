SECTION "Ball implementation", ROM0


;updateBall::
; moves ball according to velocity variables
; when bouncing of walls, vertical velocity is flipped
; when bouncing off paddles...
;                           paddle velocity is assigned to vertical v.
;                           horizontal velocity is flipped
updateBall::
    ret