SECTION "Score update", ROM0
updateScore::
    ld hl, scoreMarkerP2 + 3
    ;hl has address of units marker in score
.checkCarry
    ld a, [hl]
    cp $0E ; this is the tile after the number 9 character
    jr nz, nextMarker
    ; if z-flag set then there's a carry at the score marker

    ;first set the current character to zero
    ld a, $04
    ld [hl-], a
    ;now increment the number in the next character
    inc [hl]
    ld a, l
    cp low(scoreMarkerP2)
    jr nz,.checkCarry ;if we're not at the end of P2 marker then check next digit
nextMarker:
    ;if we just finished checking first marker then hl must hold the next markers startig address
    
    ld hl, scoreMarkerP1 + 3 ;note: h must be edited too in case it's a different value
.checkCarry
    ld a, [hl]
    cp $0E ; this is the tile after the number 9 character
    ret nz
    ; if z-flag set then there's a carry at the score marker

    ;first set the current character to zero
    ld a, $04
    ld [hl-], a
    ;now increment the number in the next character
    inc [hl]
    ld a, l
    cp low(scoreMarkerP1)
    jr nz, .checkCarry
    ret ;return if we already checked P1 marker too
