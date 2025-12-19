SECTION "VBlank Routine", ROM0

DMACode::
    LOAD "DMA routine", HRAM[$FF80]
VBlankISR::
    push af
    ld a, HIGH(OAM_Source)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 M-cycles
.wait
    dec a           ; 1 M-cycle
    jr nz, .wait    ; 3 M-cycles

    JP updateMarkerMap
    ENDL
DMACodeEnd::

updateMarkerMap::
    ;this will copy tiles one by one to finish faster... (it's not strictly necessary because of the small size though)
 
    ld a, [scoreMarkerP1 + 0]
    ld [$9800], a
    ld a, [scoreMarkerP1 + 1]
    ld [$9801], a
    ld a, [scoreMarkerP1 + 2]
    ld [$9802], a
    ld a, [scoreMarkerP1 + 3]
    ld [$9803], a
    ld a, [scoreMarkerP2 + 0]
    ld [$9810], a
    ld a, [scoreMarkerP2 + 1]
    ld [$9811], a
    ld a, [scoreMarkerP2 + 2]
    ld [$9812], a
    ld a, [scoreMarkerP2 + 3]
    ld [$9813], a
    pop af
    reti 